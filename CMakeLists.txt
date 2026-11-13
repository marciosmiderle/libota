cmake_minimum_required(VERSION 3.25)
project(LibOTA LANGUAGES C CXX)

# project modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
# libs
include(functions)

file(GLOB_RECURSE INO_FILES ${CMAKE_CURRENT_SOURCE_DIR}/examples/*.ino)
set(SRC_DIR  ${CMAKE_CURRENT_SOURCE_DIR}/src)
file(GLOB SRC_FILES ${SRC_DIR}/*.cpp)
file(GLOB HPP_FILES ${SRC_DIR}/*.hpp)
list(APPEND DEP_FILES ${HPP_FILES} ${SRC_FILES} ${INO_FILES})

option(ENABLE_EXAMPLES "Compile examples" ON)
if(ENABLE_EXAMPLES)
  find_arduino_cli_executable()
  if(ARDUINO_CLI_EXECUTABLE)
    # firmware examples

    foreach(INO_FILENAME ${INO_FILES})
      add_arduino_firmware_target(${INO_FILENAME} debug TRUE ${DEP_FILES} ${INO})
    endforeach(INO_FILENAME)

  else(ARDUINO_CLI_EXECUTABLE)
    message(WARNING "It is not possible to compile firmware images without arduino-cli.")
  endif(ARDUINO_CLI_EXECUTABLE)
endif(ENABLE_EXAMPLES)

# tests
option(ENABLE_TESTS "Activate tests" OFF)
if(ENABLE_TESTS)
  include(tests)
endif(ENABLE_TESTS)

set_property(DIRECTORY PROPERTY ADDITIONAL_CLEAN_FILES "arduino-cli cache clean")
