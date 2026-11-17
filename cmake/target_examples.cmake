file(GLOB_RECURSE INO_FILES ${CMAKE_CURRENT_SOURCE_DIR}/examples/*.ino)

find_arduino_cli_executable()
if(ARDUINO_CLI_EXECUTABLE)
  foreach(INO_FILENAME ${INO_FILES})
    add_arduino_firmware_target(${INO_FILENAME} debug TRUE ${DEP_FILES})
  endforeach()
else()
  message(WARNING "It is not possible to compile firmware images without arduino-cli.")
endif()

set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_CLEAN_FILES "arduino-cli cache clean")
