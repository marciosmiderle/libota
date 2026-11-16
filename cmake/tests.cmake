include(libs)

set(TEST_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tests)

file(GLOB CPPUTEST_SRCS "${TEST_DIR}/*.cpp")
file(GLOB TEST_SRCS	"${TEST_DIR}/src/*.cpp")
file(GLOB MOCK_SRCS	"${TEST_DIR}/mocks/*.cpp")
file(GLOB_RECURSE SNARFED_FILES "${TEST_DIR}/mocks/snarfed/*.cpp"  "${TEST_DIR}/mocks/snarfed/*.c")

set(TEST_FILES  ${CPPUTEST_SRCS})
set(LIB_SOURCES  ${TEST_SRCS} ${MOCK_SRCS} ${SNARFED_FILES} ${SRC_FILES})

add_library(ota STATIC ${LIB_SOURCES})
target_link_libraries(ota PUBLIC CppUTest CppUTestExt arduino_emulator PubSubClient httplib)
if(WIN32)
  target_link_libraries(ota PUBLIC iphlpapi)
endif()
target_include_directories(ota PUBLIC
  ${TEST_DIR}/mocks/snarfed
  ${TEST_DIR}/mocks
  ${TEST_DIR}/src
  ${TEST_DIR}
  ${SRC_DIR}
)

target_compile_options(ota PRIVATE
  -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -O0 -g3 -pipe
  $<$<COMPILE_LANGUAGE:CXX>:-Wno-overloaded-virtual>
  $<$<COMPILE_LANGUAGE:CXX>:-Wno-non-c-typedef-for-linkage>
)

set(SPECIFIC_OBJS ${TEST_DIR}/mocks/snarfed/HTTPClient.cpp)
set_source_files_properties(${SPECIFIC_OBJS}
  PROPERTIES COMPILE_OPTIONS
  "$<$<COMPILE_LANGUAGE:CXX>:-include;${SRC_DIR}/os_posix_compat.hpp>"
)

include(fixtures)

# Injeta mocks globais e compatibilidade (ex: printf, String write)
target_compile_options(ota PRIVATE
  $<$<COMPILE_LANGUAGE:CXX>:-include;${TEST_DIR}/src/TestIncludes.h>
)
target_compile_definitions(ota PRIVATE
  FIXTURES_DIR="${FIXTURES_DEST_DIR}"
  WWW_DIR="${CMAKE_BINARY_DIR}"
)

if(ENABLE_TESTS)
  add_executable(tests ${TEST_FILES})
  target_link_libraries(tests PRIVATE ota arduino_emulator httplib)
  target_compile_options(tests PRIVATE
    -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -O0 -g3 -pipe
    $<$<COMPILE_LANGUAGE:CXX>:-Wno-overloaded-virtual>
    $<$<COMPILE_LANGUAGE:CXX>:-Wno-non-c-typedef-for-linkage>
  )

  set_target_properties(tests PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/tests"
    OUTPUT_NAME "run_tests"
  )

  add_custom_target(run_tests
    COMMAND ${CMAKE_BINARY_DIR}/tests/run_tests
    DEPENDS tests
  )

  # Injeta mocks globais e compatibilidade (ex: printf, String write)
  target_compile_options(tests PRIVATE
    $<$<COMPILE_LANGUAGE:CXX>:-include;${TEST_DIR}/src/TestIncludes.h>
  )
  target_compile_definitions(tests PRIVATE
    FIXTURES_DIR="${FIXTURES_DEST_DIR}"
    WWW_DIR="${CMAKE_BINARY_DIR}"
  )
endif(ENABLE_TESTS)

include(sanitizers_option)
if(SANITIZERS_FLAGS)
  add_compile_options(${SANITIZERS_FLAGS})
  add_link_options(${SANITIZERS_FLAGS})
endif()
