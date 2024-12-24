#!/usr/bin/env bash

#
# Stores information regarding the execution of a procedure or function, and
# also records dialog information that should be shown to the user.
#
# @param ?string $1
# ::
#   - default : "-"
# ::
# Name of the function performed.
#
# @param ?int $2
# ::
#   - default : "0"
# ::
# Function output status.
# If it is not an integer, it will use **1**.
#
# @param ?string $3...--dialog
# All parameters from this position onwards refer to values returned by the
# executed function.
#
# On receiving **--dialog** stops collecting values returned by the function
# and starts feeding the dialog message.
#
# @param option $4
# ::
#   - default : "raw"
#   - list    : SHELLNS_DIALOG_DATA_TYPES
# ::
#
# Dialogue type.
#
# @param ?string $5
# Message that will be shown.
#
# @return void
shellNS_output_set() {
  shellNS_output_reset

  if [ "$#" -ge 2 ]; then
    local strResultFunction="${1:-'-'}"
    local intResultStatus="${2:-'0'}"
    local -a arrStrResultReturns=()
    local strDialogType=""
    local strDialogMessage=""
    shift 2

    if [ "$#" -ge "1" ]; then
      local paramValue=""
      for paramValue in "${@}"; do
        shift

        if [ "${paramValue}" == "--dialog" ]; then
          break
        fi
        arrStrResultReturns+=("${paramValue}")
      done

      if [ "$#" -ge "1" ]; then
        strDialogType="${1}"
        strDialogMessage="${2}"
      fi
    fi

    shellNS_result_set "${strResultFunction}" "${intResultStatus}" "${arrStrResultReturns[@]}"
    shellNS_dialog_set "${strDialogType}" "${strDialogMessage}"
  fi
}