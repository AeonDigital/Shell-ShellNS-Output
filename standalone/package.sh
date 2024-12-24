#!/usr/bin/env bash

if [[ "$(declare -p "SHELLNS_STANDALONE_LOAD_STATUS" 2> /dev/null)" != "declare -A"* ]]; then
  declare -gA SHELLNS_STANDALONE_LOAD_STATUS
fi
SHELLNS_STANDALONE_LOAD_STATUS["shellns_output_standalone.sh"]="ready"
unset SHELLNS_STANDALONE_DEPENDENCIES
declare -gA SHELLNS_STANDALONE_DEPENDENCIES
shellNS_standalone_install_set_dependency() {
  local strDownloadFileName="shellns_${2,,}_standalone.sh"
  local strPkgStandaloneURL="https://raw.githubusercontent.com/AeonDigital/${1}/refs/heads/main/standalone/package.sh"
  SHELLNS_STANDALONE_DEPENDENCIES["${strDownloadFileName}"]="${strPkgStandaloneURL}"
}
shellNS_standalone_install_set_dependency "Shell-ShellNS-Dialog" "dialog"
shellNS_standalone_install_set_dependency "Shell-ShellNS-Result" "result"
declare -gA SHELLNS_DIALOG_TYPE_COLOR=(
  ["raw"]=""
  ["info"]="\e[1;34m"
  ["warning"]="\e[0;93m"
  ["error"]="\e[1;31m"
  ["question"]="\e[1;35m"
  ["input"]="\e[1;36m"
  ["ok"]="\e[20;49;32m"
  ["fail"]="\e[20;49;31m"
)
declare -gA SHELLNS_DIALOG_TYPE_PREFIX=(
  ["raw"]=" - "
  ["info"]="inf"
  ["warning"]="war"
  ["error"]="err"
  ["question"]=" ? "
  ["input"]=" < "
  ["ok"]=" v "
  ["fail"]=" x "
)
declare -g SHELLNS_DIALOG_PROMPT_INPUT=""
shellNS_standalone_install_dialog() {
  local strDialogType="${1}"
  local strDialogMessage="${2}"
  local boolDialogWithPrompt="${3}"
  local codeColorPrefix="${SHELLNS_DIALOG_TYPE_COLOR["${strDialogType}"]}"
  local strMessagePrefix="${SHELLNS_DIALOG_TYPE_PREFIX[${strDialogType}]}"
  if [ "${strDialogMessage}" != "" ] && [ "${codeColorPrefix}" != "" ] && [ "${strMessagePrefix}" != "" ]; then
    local strIndent="        "
    local strPromptPrefix="      > "
    local codeColorNone="\e[0m"
    local codeColorText="\e[0;49m"
    local codeColorHighlight="\e[1;49m"
    local tmpCount="0"
    while [[ "${strDialogMessage}" =~ "**" ]]; do
      ((tmpCount++))
      if (( tmpCount % 2 != 0 )); then
        strDialogMessage="${strDialogMessage/\*\*/${codeColorHighlight}}"
      else
        strDialogMessage="${strDialogMessage/\*\*/${codeColorNone}}"
      fi
    done
    local codeNL=$'\n'
    strDialogMessage=$(echo -ne "${strDialogMessage}")
    strDialogMessage="${strDialogMessage//${codeNL}/${codeNL}${strIndent}}"
    local strShowMessage=""
    strShowMessage+="[ ${codeColorPrefix}${strMessagePrefix}${codeColorNone} ] "
    strShowMessage+="${codeColorText}${strDialogMessage}${codeColorNone}\n"
    echo -ne "${strShowMessage}"
    if [ "${boolDialogWithPrompt}" == "1" ]; then
      SHELLNS_DIALOG_PROMPT_INPUT=""
      read -r -p "${strPromptPrefix}" SHELLNS_DIALOG_PROMPT_INPUT
    fi
  fi
  return 0
}
shellNS_standalone_install_dependencies() {
  if [[ "$(declare -p "SHELLNS_STANDALONE_DEPENDENCIES" 2> /dev/null)" != "declare -A"* ]]; then
    return 0
  fi
  if [ "${#SHELLNS_STANDALONE_DEPENDENCIES[@]}" == "0" ]; then
    return 0
  fi
  local pkgFileName=""
  local pkgSourceURL=""
  local pgkLoadStatus=""
  for pkgFileName in "${!SHELLNS_STANDALONE_DEPENDENCIES[@]}"; do
    pgkLoadStatus="${SHELLNS_STANDALONE_LOAD_STATUS[${pkgFileName}]}"
    if [ "${pgkLoadStatus}" == "" ]; then pgkLoadStatus="0"; fi
    if [ "${pgkLoadStatus}" == "ready" ] || [ "${pgkLoadStatus}" -ge "1" ]; then
      continue
    fi
    if [ ! -f "${pkgFileName}" ]; then
      pkgSourceURL="${SHELLNS_STANDALONE_DEPENDENCIES[${pkgFileName}]}"
      curl -o "${pkgFileName}" "${pkgSourceURL}"
      if [ ! -f "${pkgFileName}" ]; then
        local strMsg=""
        strMsg+="An error occurred while downloading a dependency.\n"
        strMsg+="URL: **${pkgSourceURL}**\n\n"
        strMsg+="This execution was aborted."
        shellNS_standalone_install_dialog "error" "${strMsg}"
        return 1
      fi
    fi
    chmod +x "${pkgFileName}"
    if [ "$?" != "0" ]; then
      local strMsg=""
      strMsg+="Could not give execute permission to script:\n"
      strMsg+="FILE: **${pkgFileName}**\n\n"
      strMsg+="This execution was aborted."
      shellNS_standalone_install_dialog "error" "${strMsg}"
      return 1
    fi
    SHELLNS_STANDALONE_LOAD_STATUS["${pkgFileName}"]="1"
  done
  if [ "${1}" == "1" ]; then
    for pkgFileName in "${!SHELLNS_STANDALONE_DEPENDENCIES[@]}"; do
      pgkLoadStatus="${SHELLNS_STANDALONE_LOAD_STATUS[${pkgFileName}]}"
      if [ "${pgkLoadStatus}" == "ready" ]; then
        continue
      fi
      . "${pkgFileName}"
      if [ "$?" != "0" ]; then
        local strMsg=""
        strMsg+="An unexpected error occurred while load script:\n"
        strMsg+="FILE: **${pkgFileName}**\n\n"
        strMsg+="This execution was aborted."
        shellNS_standalone_install_dialog "error" "${strMsg}"
        return 1
      fi
      SHELLNS_STANDALONE_LOAD_STATUS["${pkgFileName}"]="ready"
    done
  fi
}
shellNS_standalone_install_dependencies "1"
unset shellNS_standalone_install_set_dependency
unset shellNS_standalone_install_dependencies
unset shellNS_standalone_install_dialog
unset SHELLNS_STANDALONE_DEPENDENCIES
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
shellNS_output_reset() {
  shellNS_result_reset
  shellNS_dialog_reset
}
SHELLNS_TMP_PATH_TO_DIR_MANUALS="$(tmpPath=$(dirname "${BASH_SOURCE[0]}"); realpath "${tmpPath}/src-manuals/${SHELLNS_CONFIG_INTERFACE_LOCALE}")"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_output_reset"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/output/reset.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_output_set"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/output/set.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_output_show"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/output/show.man"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["output.reset"]="shellNS_output_reset"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["output.set"]="shellNS_output_set"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["output.show"]="shellNS_output_show"
unset SHELLNS_TMP_PATH_TO_DIR_MANUALS
