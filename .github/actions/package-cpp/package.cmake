# Copyright (c) 2023 - 2026 Chair for Design Automation, TUM
# Copyright (c) 2025 - 2026 Munich Quantum Software Company GmbH
# All rights reserved.
#
# SPDX-License-Identifier: MIT
#
# Licensed under the MIT License

cmake_minimum_required(VERSION 3.24)
set(source "${CMAKE_CURRENT_BINARY_DIR}")
set(work "${source}/build/packaging")
file(READ "${source}/.github/cpp-packaging.json" config)
foreach(key package install-prefix)
  string(JSON ${key} GET "${config}" "${key}")
endforeach()
if(NOT package MATCHES "^[A-Za-z_][A-Za-z0-9_.-]*$"
   OR IS_ABSOLUTE "${install-prefix}"
   OR install-prefix MATCHES "(^|/)[.][.](/|$)|[\\\\:]")
  message(FATAL_ERROR "Invalid C++ packaging configuration")
endif()

function(run)
  execute_process(COMMAND ${ARGV} COMMAND_ERROR_IS_FATAL ANY)
endfunction()

file(GLOB wheels "${source}/wheelhouse/*.whl")
list(FILTER wheels EXCLUDE REGEX "musllinux")
if(NOT wheels)
  message(FATAL_ERROR "Expected at least one non-musllinux wheel")
endif()
list(GET wheels 0 wheel)
get_filename_component(wheel_name "${wheel}" NAME)
string(REGEX REPLACE "^.*-([^-]+)\\.whl$" "\\1" platform "${wheel_name}")
if(NOT platform MATCHES "^[A-Za-z0-9_.]+$")
  message(FATAL_ERROR "Invalid wheel platform")
endif()
file(REMOVE_RECURSE "${work}")
file(MAKE_DIRECTORY "${work}/wheel")
execute_process(COMMAND "${CMAKE_COMMAND}" -E tar tf "${wheel}"
                OUTPUT_VARIABLE entries COMMAND_ERROR_IS_FATAL ANY)
string(REPLACE "\n" ";" entries "${entries}")
foreach(entry IN LISTS entries)
  if(entry MATCHES "^/|(^|/)[.][.](/|$)|[\\\\:]")
    message(FATAL_ERROR "Unsafe wheel path: ${entry}")
  endif()
endforeach()
# ZIP timestamps can appear in the future when extracted in another timezone.
file(ARCHIVE_EXTRACT INPUT "${wheel}" DESTINATION "${work}/wheel" TOUCH)
file(
  GLOB_RECURSE extracted
  LIST_DIRECTORIES true
  "${work}/wheel/*")
foreach(entry IN LISTS extracted)
  if(IS_SYMLINK "${entry}")
    message(FATAL_ERROR "Wheel contains a symbolic link: ${entry}")
  endif()
endforeach()
if(APPLE)
  run(uvx --from delocate delocate-path --lib-path lib
      "${work}/wheel/${install-prefix}")
else()
  file(GLOB bundled "${work}/wheel/*.libs/*" "${work}/wheel/*.dylibs/*")
endif()
set(prefix "${work}/prefix/${package}")
foreach(directory bin include lib lib64 share)
  if(IS_DIRECTORY "${work}/wheel/${install-prefix}/${directory}")
    file(COPY "${work}/wheel/${install-prefix}/${directory}"
         DESTINATION "${prefix}")
  endif()
endforeach()
file(GLOB notices "${work}/wheel/*.dist-info/licenses")
list(LENGTH notices count)
if(NOT count EQUAL 1 OR NOT IS_DIRECTORY "${prefix}/include")
  message(FATAL_ERROR "The wheel must contain C++ headers and license notices")
endif()
file(COPY ${notices} DESTINATION "${prefix}")

if(WIN32)
  set(library_dir "${prefix}/bin")
elseif(IS_DIRECTORY "${prefix}/lib64" AND NOT IS_DIRECTORY "${prefix}/lib")
  set(library_dir "${prefix}/lib64")
else()
  set(library_dir "${prefix}/lib")
endif()
foreach(library IN LISTS bundled)
  get_filename_component(library_name "${library}" NAME)
  if(NOT library_name MATCHES "^[A-Za-z0-9_.+-]+$"
     OR EXISTS "${library_dir}/${library_name}")
    message(
      FATAL_ERROR "Invalid or conflicting runtime library: ${library_name}")
  endif()
  file(COPY "${library}" DESTINATION "${library_dir}")
endforeach()

file(GLOB metadata "${work}/wheel/*.dist-info/METADATA")
list(LENGTH metadata count)
if(NOT count EQUAL 1)
  message(FATAL_ERROR "Expected one wheel metadata file")
endif()
file(
  STRINGS "${metadata}" version
  REGEX "^Version:"
  LIMIT_COUNT 1)
string(REGEX REPLACE "^Version: *" "" version "${version}")
if(NOT version MATCHES "^[A-Za-z0-9][A-Za-z0-9.+_-]*$")
  message(FATAL_ERROR "Invalid wheel version")
endif()
string(TOLOWER "${package}" lowercase_package)
file(GLOB_RECURSE version_file "${prefix}/${package}ConfigVersion.cmake"
     "${prefix}/${lowercase_package}-config-version.cmake"
     "${prefix}/${package}-config-version.cmake")
list(LENGTH version_file count)
if(NOT count EQUAL 1)
  message(FATAL_ERROR "Expected one CMake version file for ${package}")
endif()
include("${version_file}")
if(NOT version VERSION_EQUAL PACKAGE_VERSION)
  message(FATAL_ERROR "Wheel and CMake package versions differ")
endif()
set(name "${package}_v${version}_${platform}.tar.gz")
file(MAKE_DIRECTORY "${source}/dist")
execute_process(
  COMMAND "${CMAKE_COMMAND}" -E tar czf "${source}/dist/${name}" "${package}"
  WORKING_DIRECTORY "${work}/prefix" COMMAND_ERROR_IS_FATAL ANY)
file(ARCHIVE_EXTRACT INPUT "${source}/dist/${name}" DESTINATION
     "${work}/extracted")
file(REMOVE_RECURSE "${work}/prefix" "${work}/wheel")
set(ENV{CMAKE_GENERATOR} Ninja)
run("${CMAKE_COMMAND}" "-Dinstalled_prefix=${work}/extracted/${package}" -P
    "${source}/test/install.cmake")
