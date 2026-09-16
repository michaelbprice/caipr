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
set_target_properties(caipr PROPERTIES CXX_EXTENSIONS OFF)

include(CTest)

if(BUILD_TESTING)
  add_subdirectory(test)
endif()

