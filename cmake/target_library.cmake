file(GLOB SRC_FILES ${SRC_DIR}/*.cpp)
file(GLOB HPP_FILES ${SRC_DIR}/*.hpp)

file(GLOB TEST_SRCS     "${TEST_DIR}/src/*.cpp")
file(GLOB MOCK_SRCS     "${TEST_DIR}/mocks/*.cpp")
file(GLOB_RECURSE SNARFED_FILES
  "${TEST_DIR}/mocks/snarfed/*.cpp"
  "${TEST_DIR}/mocks/snarfed/*.c"
)

set(LIB_SOURCES ${SRC_FILES} ${TEST_SRCS} ${MOCK_SRCS} ${SNARFED_FILES})
list(APPEND DEP_FILES ${HPP_FILES} ${SRC_FILES})

add_library(LibOTA STATIC ${LIB_SOURCES} ${HPP_FILES})
set_target_properties(LibOTA PROPERTIES OUTPUT_NAME ota)

target_include_directories(LibOTA PUBLIC
  ${TEST_DIR}/mocks/snarfed
  ${TEST_DIR}/mocks
  ${TEST_DIR}/src
  ${TEST_DIR}
  ${SRC_DIR}
)
target_link_libraries(LibOTA PUBLIC arduino_emulator PubSubClient httplib)

if(TARGET CppUTest)
  target_link_libraries(LibOTA PUBLIC CppUTest CppUTestExt)
endif()

if(WIN32)
  target_link_libraries(arduino_emulator PUBLIC iphlpapi)
endif()

target_compile_options(LibOTA PRIVATE
  -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -O0 -g3 -pipe
  $<$<COMPILE_LANGUAGE:CXX>:-Wno-overloaded-virtual>
  $<$<COMPILE_LANGUAGE:CXX>:-Wno-non-c-typedef-for-linkage>
  $<$<COMPILE_LANGUAGE:CXX>:-include;${TEST_DIR}/src/TestIncludes.h>
)

if(LIBOTA_ENABLE_TESTS)
  target_compile_definitions(LibOTA PRIVATE
    FIXTURES_DIR="${FIXTURES_DEST_DIR}"
    WWW_DIR="${CMAKE_BINARY_DIR}"
  )
endif()

set(SPECIFIC_OBJS ${TEST_DIR}/mocks/snarfed/HTTPClient.cpp)
set_source_files_properties(${SPECIFIC_OBJS}
  PROPERTIES COMPILE_OPTIONS
  "$<$<COMPILE_LANGUAGE:CXX>:-include;${SRC_DIR}/os_posix_compat.hpp>"
  COMPILE_DEFINITIONS "HTTPCLIENT_NOSECURE"
)

target_apply_sanitizers(LibOTA)
