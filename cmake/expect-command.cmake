# Runs a command and verifies its exit code plus optional output expectations.
#
# Required variables:
# - CAIPR_EXECUTABLE: executable path to run
# - CAIPR_EXPECTED_RESULT: expected process exit code
#
# Optional variables:
# - CAIPR_ARGUMENTS: pipe-separated list of command arguments; pipes avoid
#   semicolon list expansion in -D values
# - CAIPR_EXPECTED_OUTPUT: expected stdout after trimming whitespace
# - CAIPR_EXPECTED_ERROR: substring expected in stderr
if(DEFINED CAIPR_ARGUMENTS)
  string(REPLACE "|" ";" CAIPR_ARGUMENTS "${CAIPR_ARGUMENTS}")
endif()

execute_process(
  COMMAND "${CAIPR_EXECUTABLE}" ${CAIPR_ARGUMENTS}
  RESULT_VARIABLE actual_result
  OUTPUT_VARIABLE actual_output
  ERROR_VARIABLE actual_error
)

if(NOT CAIPR_EXPECTED_RESULT MATCHES "^[0-9]+$")
  message(FATAL_ERROR "expected result must be numeric: ${CAIPR_EXPECTED_RESULT}")
endif()

if(NOT actual_result MATCHES "^[0-9]+$")
  message(
    FATAL_ERROR
    "command did not produce a numeric exit code: ${actual_result}\n"
    "stdout: ${actual_output}\n"
    "stderr: ${actual_error}"
  )
endif()

if(NOT actual_result EQUAL "${CAIPR_EXPECTED_RESULT}")
  message(
    FATAL_ERROR
    "expected result ${CAIPR_EXPECTED_RESULT}, got ${actual_result}\n"
    "stdout: ${actual_output}\n"
    "stderr: ${actual_error}"
  )
endif()

if(DEFINED CAIPR_EXPECTED_OUTPUT)
  string(STRIP "${actual_output}" actual_output_stripped)
  if(NOT actual_output_stripped STREQUAL "${CAIPR_EXPECTED_OUTPUT}")
    message(
      FATAL_ERROR
      "expected stdout: ${CAIPR_EXPECTED_OUTPUT}\n"
      "actual stdout: ${actual_output}"
    )
  endif()
endif()

if(DEFINED CAIPR_EXPECTED_ERROR)
  string(FIND "${actual_error}" "${CAIPR_EXPECTED_ERROR}" expected_error_position)
  if(expected_error_position EQUAL -1)
    message(
      FATAL_ERROR
      "expected stderr to contain: ${CAIPR_EXPECTED_ERROR}\n"
      "actual stderr: ${actual_error}"
    )
  endif()
endif()
