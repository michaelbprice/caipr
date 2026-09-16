cmake_minimum_required(VERSION 3.20)

project(
  caipr
  VERSION 0.1.0
  DESCRIPTION "C++ AI Powered Refinery"
  LANGUAGES CXX
)

add_executable(caipr src/caipr.cpp)
target_compile_features(caipr PRIVATE cxx_std_23)
target_compile_definitions(caipr PRIVATE CAIPR_VERSION="${PROJECT_VERSION}")

include(CTest)

if(BUILD_TESTING)
  add_test(NAME caipr.version COMMAND caipr --version)
  set_tests_properties(caipr.version PROPERTIES PASS_REGULAR_EXPRESSION "^caipr ${PROJECT_VERSION}")
endif()

