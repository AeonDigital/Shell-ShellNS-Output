#!/usr/bin/env bash

#
# Get path to the manuals directory.
SHELLNS_TMP_PATH_TO_DIR_MANUALS="$(tmpPath=$(dirname "${BASH_SOURCE[0]}"); realpath "${tmpPath}/src-manuals/${SHELLNS_CONFIG_INTERFACE_LOCALE}")"


#
# Mapp function to manual.
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_output_reset"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/output/reset.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_output_set"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/output/set.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_output_show"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/output/show.man"


#
# Mapp namespace to function.
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["output.reset"]="shellNS_output_reset"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["output.set"]="shellNS_output_set"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["output.show"]="shellNS_output_show"





unset SHELLNS_TMP_PATH_TO_DIR_MANUALS