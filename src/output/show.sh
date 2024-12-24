#!/usr/bin/env bash

#
# Prints the last recorded output information on the screen.
#
# Wrapper para **shellNS_result_show** e **shellNS_dialog_show**.
#
# By default, it resets the values stored in the **SHELLNS_RESULT_DATA** and
# **SHELLNS_DIALOG_DATA** arrays.
#
# @param ?int $1
# Number of the parameter that should be returned.  
# If it is not informed, it will take the first.
#
# If the value entered is invalid, it will not print anything and return the
# value status of **255**.
#
#
# @param ?bool $2
# ::
#   - default : "0"
#   - list    : SHELLNS_PROMPT_OPTION_BOOL
# ::
# If **1** will preserve the values of the data arrays avoiding their reset.
#
#
# @param ?bool $3
# ::
#   - default : "0"
#   - list    : SHELLNS_PROMPT_OPTION_BOOL
# ::
# If **1** will omit the dialog message.
#
# @return status+?string
# Returns the last registered status code and prints the dialog message, if it
# exists.
shellNS_output_show() {
  local intTargetReturn="0"
  if [[ "${1}" =~ ^-?[0-9]+$ ]]; then
    intTargetReturn="${1}"
  fi

  if [ "${#SHELLNS_RESULT_RETURN[@]}" -gt "0" ] && [ "${intTargetReturn}" -ge "${#SHELLNS_RESULT_RETURN[@]}" ]; then
    return 255
  fi


  local useOutputStr=""
  local useOutputStatus="${SHELLNS_RESULT_DATA["status"]}"

  local resultShow=$(shellNS_result_show "${intTargetReturn}")
  local dialogShow=""
  if [ "${3}" != "1" ]; then
    dialogShow=$(shellNS_dialog_show)
  fi


  local boolPreserveOutput="0"
  if [ "${2}" == "1" ]; then boolPreserveOutput="1"; fi
  if [ "${boolPreserveOutput}" == "0" ]; then
    shellNS_output_reset
  fi


  if [ "${resultShow}" != "" ]; then
    useOutputStr+=$(echo -n "${resultShow}")
  fi

  if [ "${dialogShow}" != "" ]; then
    if [ "${resultShow}" != "" ]; then
      useOutputStr+=$'\n'
      useOutputStr+=$'\n'
    fi
    useOutputStr+=$(echo -n "${dialogShow}")
  fi

  if [ "${useOutputStr}" != "" ]; then
    echo "${useOutputStr}"
  fi
  return "${useOutputStatus}"
}