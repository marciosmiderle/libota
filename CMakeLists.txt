cmake_minimum_required(VERSION 3.25)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  project(LibOTA LANGUAGES C CXX)
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(SRC_DIR  "${CMAKE_CURRENT_SOURCE_DIR}/src")
set(TEST_DIR "${CMAKE_CURRENT_SOURCE_DIR}/tests")

include(options)
include(sanitizers)
include(libs_dependencies)

if(ENABLE_TESTS)
  include(fixtures)
  include(libs_cpputest)
endif()

include(target_library)
include(functions)

if(ENABLE_EXAMPLES)
  include(target_examples)
endif()

if(ENABLE_TESTS)
  include(target_tests)
endif()
