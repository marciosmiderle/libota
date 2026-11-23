include(CheckCXXCompilerFlag)

set(SANITIZERS_FLAGS "")

function(check_sanitizer_flag FLAG OUT_VAR)
  set(CMAKE_REQUIRED_LINK_OPTIONS "${FLAG}")
  check_cxx_compiler_flag("${FLAG}" ${OUT_VAR})
  unset(CMAKE_REQUIRED_LINK_OPTIONS)
  set(${OUT_VAR} ${${OUT_VAR}} PARENT_SCOPE)
endfunction()

if(LIBOTA_ENABLE_SANITIZERS)
  check_sanitizer_flag("-fsanitize=address" HAS_ASAN)
  if(HAS_ASAN)
    list(APPEND SANITIZERS_FLAGS "-fsanitize=address")
  endif()

  check_sanitizer_flag("-fsanitize=undefined" HAS_UBSAN)
  if(HAS_UBSAN)
    list(APPEND SANITIZERS_FLAGS "-fsanitize=undefined")
  endif()

  check_sanitizer_flag("-fsanitize=leak" HAS_LSAN)
  if(HAS_LSAN AND NOT HAS_ASAN)
    list(APPEND SANITIZERS_FLAGS "-fsanitize=leak")
  endif()
endif()

function(target_apply_sanitizers TGT)
  if(SANITIZERS_FLAGS)
    target_compile_options(${TGT} PRIVATE ${SANITIZERS_FLAGS})
    target_link_options(${TGT} PUBLIC ${SANITIZERS_FLAGS})
  endif()
endfunction()
