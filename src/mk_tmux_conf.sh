#!/usr/bin/env bash
#
# Make tmux configuration file

set -o errexit   # Exit if non-zero exit code, ...
set -o nounset   # Exit if unset variables, ...
set -o pipefail  # Exit if non-zero exit code, ...

readonly SCRIPT_NAME="${0##*/}"
readonly PATH_DIR=$(dirname $(readlink -f $0))
readonly PATH_TMUX="${PATH_DIR}/../bin/dotfiles/tmux"
readonly FP_TMUX_BASE="${PATH_TMUX}/.tmux-base.conf"
readonly FP_TMUX_THEME_TEMPLATE="${PATH_TMUX}/.tmux-theme-template.conf"
readonly TMUX_THEME_TEMPLATE_VAR_PRIMARY_COLOR="\${PRIMARY_COLOR}"
readonly TMUX_THEME_TEMPLATE_VAR_SECONDARY_COLOR="\${SECONDARY_COLOR}"

source "${PATH_DIR}/utils.sh"
LOG_LVL=1

readonly DFLT_PRIMARY_COLOR="#2196f3"
readonly DFLT_SECONDARY_COLOR="#64b5f6"
readonly DFLT_FP_OUTPUT="${PATH_TMUX}/.tmux.conf"


function display_help()
{
  print_underlined "Help"
  printf "Create tmux theme\n"
  printf "Options:\n"
  printf "\t-h \t\tDisplay this message.\n"
  printf "\t-o \t\tOutput file path (default: ${DFLT_FP_OUTPUT})\n"
  printf "\t-p \t\tPrimary color (default: ${DFLT_PRIMARY_COLOR})\n"
  printf "\t-s \t\tSecondary color (default: ${DFLT_SECONDARY_COLOR})\n"
  printf "\t   \t\t- 256 colors set: https://gist.github.com/jasonm23/2868981\n"
  printf "Examples:\n"
  printf "\t${PATH_DIR}/${SCRIPT_NAME} -p '#2196f3' -s '#64b5f6'\n"
  printf "\t${PATH_DIR}/${SCRIPT_NAME} -o ~/.tmux.conf -p 'colour208' -s '#ffaf00'\n"
  printf "\n"
}


function main()
{
  # cfg
  # ---------------------------------------------------------------------------
  local primary_color="${DFLT_PRIMARY_COLOR}"
  local secondary_color="${DFLT_SECONDARY_COLOR}"
  local fp_output="${DFLT_FP_OUTPUT}"

  local OPTIND=1  # Reset getopts OPTIND
  while getopts ":ho:p:s:" flag; do
    case "${flag}" in
      h)
        display_help
        exit 0
        ;;
      o) fp_output="${OPTARG}" ;;
      p) primary_color="${OPTARG}" ;;
      s) secondary_color="${OPTARG}" ;;
      *)
        log_err "Unsupported option: ${flag}\n"
        display_help
        exit 1
        ;;
    esac
  done

  # exec
  # ---------------------------------------------------------------------------
  print_underlined "Making tmux configuration file"

  cp "${PATH_TMUX}/.tmux-base.conf" "${fp_output}"
  cat "${FP_TMUX_THEME_TEMPLATE}" | sed                                 \
    -e s/${TMUX_THEME_TEMPLATE_VAR_PRIMARY_COLOR}/${primary_color}/     \
    -e s/${TMUX_THEME_TEMPLATE_VAR_SECONDARY_COLOR}/${secondary_color}/ \
    >> "${fp_output}"

  log_inf "Done. output file path: ${fp_output}, theme:"
  log_inf "- Primary color: ${primary_color}"
  log_inf "- Secondary color: ${secondary_color}"
}

main "$@"
