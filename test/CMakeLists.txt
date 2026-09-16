add_test(
  NAME caipr.version
  COMMAND
    "${CMAKE_COMMAND}"
    "-DCAIPR_EXECUTABLE=$<TARGET_FILE:caipr>"
    "-DCAIPR_ARGUMENTS=--version"
    "-DCAIPR_EXPECTED_RESULT=0"
    "-DCAIPR_EXPECTED_OUTPUT=caipr ${PROJECT_VERSION}"
    -P "${PROJECT_SOURCE_DIR}/cmake/expect-command.cmake"
)
add_test(
  NAME caipr.rejects-extra-args
  COMMAND
    "${CMAKE_COMMAND}"
    "-DCAIPR_EXECUTABLE=$<TARGET_FILE:caipr>"
    "-DCAIPR_ARGUMENTS=--version|extra"
    "-DCAIPR_EXPECTED_RESULT=2"
    "-DCAIPR_EXPECTED_ERROR=caipr: expected at most one argument; usage: caipr [--version]"
    -P "${PROJECT_SOURCE_DIR}/cmake/expect-command.cmake"
)
add_test(
  NAME caipr.rejects-unknown-option
  COMMAND
    "${CMAKE_COMMAND}"
    "-DCAIPR_EXECUTABLE=$<TARGET_FILE:caipr>"
    "-DCAIPR_ARGUMENTS=--unknown"
    "-DCAIPR_EXPECTED_RESULT=2"
    "-DCAIPR_EXPECTED_ERROR=caipr: unsupported option '--unknown'; usage: caipr [--version]"
    -P "${PROJECT_SOURCE_DIR}/cmake/expect-command.cmake"
)