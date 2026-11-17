if(NOT DEFINED ENABLE_EXAMPLES)
  option(ENABLE_EXAMPLES "Compile examples" OFF)
endif()

if(NOT DEFINED ENABLE_TESTS)
  option(ENABLE_TESTS "Activate tests" OFF)
endif()

if(NOT DEFINED ENABLE_SANITIZERS)
  option(ENABLE_SANITIZERS "Activate memory and behavior sanitizers" ON)
endif()
