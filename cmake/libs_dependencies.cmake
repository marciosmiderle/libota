include(FetchContent)

FetchContent_Declare(
  arduino_emulator
  GIT_REPOSITORY https://github.com/pschatzmann/Arduino-Emulator
  GIT_TAG        main
)
FetchContent_MakeAvailable(arduino_emulator)
include(${arduino_emulator_SOURCE_DIR}/Arduino.cmake)

arduino_library(PubSubClient https://github.com/knolleary/pubsubclient.git v2.8)

FetchContent_Declare(
  cpp-httplib
  GIT_REPOSITORY https://github.com/yhirose/cpp-httplib
  GIT_TAG        v0.65.0
)
FetchContent_MakeAvailable(cpp-httplib)
