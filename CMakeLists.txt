cmake_minimum_required(VERSION 3.25)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  project(LibOTA LANGUAGES C CXX)
  set(LIBOTA_IS_TOP_LEVEL TRUE)
else()
  set(LIBOTA_IS_TOP_LEVEL FALSE)
endif()

set(SRC_DIR  "${CMAKE_CURRENT_SOURCE_DIR}/src")
set(TEST_DIR "${CMAKE_CURRENT_SOURCE_DIR}/tests")

include(cmake/options.cmake)
include(cmake/sanitizers.cmake)
include(cmake/libs_dependencies.cmake)

if(LIBOTA_ENABLE_TESTS)
  if(LIBOTA_IS_TOP_LEVEL)
    include(cmake/fixtures.cmake)
    include(cmake/libs_cpputest.cmake)
  endif()
  include(cmake/target_library.cmake)
endif()

if(LIBOTA_ENABLE_EXAMPLES)
  include(cmake/functions.cmake)
  include(cmake/target_examples.cmake)
endif()

if(LIBOTA_ENABLE_TESTS AND LIBOTA_IS_TOP_LEVEL)
  include(cmake/target_tests.cmake)
endif()
