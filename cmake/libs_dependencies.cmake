cmake_policy(SET CMP0169 OLD)
include(FetchContent)

FetchContent_Declare(
  arduino_emulator
  GIT_REPOSITORY https://github.com/pschatzmann/Arduino-Emulator
  GIT_TAG        main
)

FetchContent_Declare(
  cpp-httplib
  GIT_REPOSITORY https://github.com/yhirose/cpp-httplib
  GIT_TAG        v0.65.0
)

if(LIBOTA_ENABLE_TESTS)

  set(USE_HTTPS false)
  FetchContent_MakeAvailable(arduino_emulator cpp-httplib)
  include(${arduino_emulator_SOURCE_DIR}/Arduino.cmake)
  arduino_library(PubSubClient https://github.com/knolleary/pubsubclient.git v2.8)

else()

  FetchContent_GetProperties(arduino_emulator)
  if(NOT arduino_emulator_POPULATED)
    FetchContent_Populate(arduino_emulator)
  endif()
  include(${arduino_emulator_SOURCE_DIR}/Arduino.cmake)

endif()
