if(NOT DEFINED LIBOTA_ENABLE_EXAMPLES)
  option(LIBOTA_ENABLE_EXAMPLES "Compile examples" OFF)
endif()

if(NOT DEFINED LIBOTA_ENABLE_TESTS)
  option(LIBOTA_ENABLE_TESTS "Activate tests" ON)
endif()

if(NOT DEFINED LIBOTA_ENABLE_SANITIZERS)
  option(LIBOTA_ENABLE_SANITIZERS "Activate memory and behavior sanitizers" ON)
endif()

# show status
if(LIBOTA_ENABLE_EXAMPLES)
  message(STATUS "Compile examples ON")
endif()
if(LIBOTA_ENABLE_TESTS)
  message(STATUS "Activate tests ON")
endif()
if(LIBOTA_ENABLE_SANITIZERS)
  message(STATUS "Activate memory and behavior sanitizers ON")
endif()
