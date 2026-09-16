execute_process(
  COMMAND "${CAIPR_EXECUTABLE}" ${CAIPR_ARGUMENTS}
  RESULT_VARIABLE actual_result
  OUTPUT_VARIABLE actual_output
  ERROR_VARIABLE actual_error
)

if(NOT actual_result EQUAL "${CAIPR_EXPECTED_RESULT}")
  message(
    FATAL_ERROR
    "expected result ${CAIPR_EXPECTED_RESULT}, got ${actual_result}\n"
    "stdout: ${actual_output}\n"
    "stderr: ${actual_error}"
  )
endif()

string(FIND "${actual_error}" "${CAIPR_EXPECTED_ERROR}" expected_error_position)
if(expected_error_position EQUAL -1)
  message(
    FATAL_ERROR
    "expected stderr to contain: ${CAIPR_EXPECTED_ERROR}\n"
    "actual stderr: ${actual_error}"
  )
endif()

