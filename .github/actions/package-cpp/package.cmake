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
string(JSON triple GET "${config}" platforms "$ENV{CPP_PACKAGING_PLATFORM}")
if(NOT package MATCHES "^[A-Za-z_][A-Za-z0-9_.-]*$"
   OR NOT triple MATCHES "^[a-z0-9_]+(-[a-z0-9_]+)+$"
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
set(prefix "${work}/prefix/${package}")
file(COPY "${work}/wheel/${install-prefix}/" DESTINATION "${prefix}")
file(GLOB notices "${work}/wheel/*.dist-info/licenses")
list(LENGTH notices count)
if(NOT count EQUAL 1 OR NOT IS_DIRECTORY "${prefix}/include")
  message(FATAL_ERROR "The wheel must contain C++ headers and license notices")
endif()
file(COPY ${notices} DESTINATION "${prefix}")

if(WIN32)
  set(library_dir "${prefix}/bin")
else()
  file(GLOB library_dirs "${prefix}/lib*")
  list(GET library_dirs 0 library_dir)
endif()
file(GLOB bundled "${work}/wheel/*.libs/*" "${work}/wheel/*.dylibs/*")
if(APPLE AND bundled)
  message(
    FATAL_ERROR
      "Bundled macOS libraries require a tested relocation implementation")
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
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
  find_program(PATCHELF_EXECUTABLE patchelf REQUIRED)
  file(GLOB libraries "${library_dir}/*.so*")
  foreach(library IN LISTS libraries)
    run("${PATCHELF_EXECUTABLE}" --set-rpath "$ORIGIN" "${library}")
  endforeach()
endif()

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
file(GLOB_RECURSE version_file "${prefix}/${package}-config-version.cmake")
include("${version_file}")
if(NOT version VERSION_EQUAL PACKAGE_VERSION)
  message(FATAL_ERROR "Wheel and CMake package versions differ")
endif()
set(name "${package}_v${version}_${triple}.tar.gz")
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
