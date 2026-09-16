cmake_minimum_required(VERSION 3.21)

project(
  caipr
  VERSION 0.1.0
  DESCRIPTION "C++ AI Powered Refinery"
  LANGUAGES CXX
)

add_executable(caipr src/caipr.cpp)
target_compile_features(caipr PRIVATE cxx_std_23)
target_compile_definitions(caipr PRIVATE CAIPR_VERSION="${PROJECT_VERSION}")
set_target_properties(caipr PROPERTIES CXX_STANDARD_REQUIRED ON CXX_EXTENSIONS OFF)

include(CTest)

if(BUILD_TESTING)
  add_test(NAME caipr.version COMMAND caipr --version)
  add_test(
    NAME caipr.rejects-extra-args
    COMMAND
      "${CMAKE_COMMAND}"
      "-DCAIPR_EXECUTABLE=$<TARGET_FILE:caipr>"
      "-DCAIPR_ARGUMENTS=--version;extra"
      "-DCAIPR_EXPECTED_RESULT=2"
      "-DCAIPR_EXPECTED_ERROR=caipr: expected at most one argument; usage: caipr [--version]"
      -P "${CMAKE_CURRENT_SOURCE_DIR}/cmake/expect-command.cmake"
  )
  add_test(
    NAME caipr.rejects-unknown-option
    COMMAND
      "${CMAKE_COMMAND}"
      "-DCAIPR_EXECUTABLE=$<TARGET_FILE:caipr>"
      "-DCAIPR_ARGUMENTS=--unknown"
      "-DCAIPR_EXPECTED_RESULT=2"
      "-DCAIPR_EXPECTED_ERROR=caipr: unsupported option '--unknown'; usage: caipr [--version]"
      -P "${CMAKE_CURRENT_SOURCE_DIR}/cmake/expect-command.cmake"
  )
  set_tests_properties(caipr.version PROPERTIES PASS_REGULAR_EXPRESSION "^caipr ${PROJECT_VERSION}")
endif()
