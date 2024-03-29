#!/usr/bin/env bash


# Execution
# -----------------------------------------------------------------------------
function keyboard_interrupt()
{
  printf "\n[ERR]: Keyboard Interrupt.\n" >&2
  exit 1
}

trap keyboard_interrupt SIGINT # SIGTSTP SIGABRT SIGHUP SIGQUIT SIGTERM


# Input
# -----------------------------------------------------------------------------
#######################################
# Arguments:
# - str         : Question
# - str [opt.]  : Default value (Y || N)
# Example:
# - input_yes_or_no "Hello world?"
# Returns:
# - bool: Yes/No
#######################################
input_yes_or_no()
{
  local prompt default reply

  if [[ ${2:-} = "Y" ]]; then
    prompt="Y/n"
    default="Y"
  elif [[ ${2:-} = "N" ]]; then
    prompt="y/N"
    default="N"
  else
    prompt="y/n"
    default=""
  fi

  while true; do
    # Ask the question (without read -p)
    if [[ $default = "Y" ]] || [[ $default = "N" ]]; then
      printf "$1 [$prompt] (default: $default)\n> "
    else
      printf "$1 [$prompt]\n> "
    fi

    # Read the answer (from /dev/tty to handle stdin redirection)
    read -r reply </dev/tty

    # Default?
    if [[ -z $reply ]]; then
      reply=$default
    fi

    # Check if the reply is valid
    case "$reply" in
      Y*|y*) return 0 ;;
      N*|n*) return 1 ;;
    esac
  done
}

export -f input_yes_or_no


# Logging
# -----------------------------------------------------------------------------
# Levels: -1: None, 0: Error, 1: Info, 2: Debug
LOG_LVL=2

#######################################
# Globals:
# - LOG_LVL
# Arguments:
# - str         : text to output
# Outputs:
# - Writes to stderr if LOG_LVL ge 0
#######################################
function log_err()
{
  if [[ $LOG_LVL -ge 0 ]]; then
    printf "[ERR]: $*\n" >&2
  fi
}

export -f log_err

#######################################
# Globals:
# - LOG_LVL
# Arguments:
# - str         : text to output
# Outputs:
# - Writes to stdout if LOG_LVL ge 1
#######################################
function log_inf()
{
  if [[ $LOG_LVL -ge 1 ]]; then
    printf "[INF]: $*\n"
  fi
}

export -f log_inf

#######################################
# Globals:
# - LOG_LVL
# Arguments:
# - str         : text to output
# Outputs:
# - Writes to stdout if LOG_LVL ge 2
#######################################
function log_dbg()
{
  if [[ $LOG_LVL -ge 2 ]]; then
    printf "[DBG]: $*\n"
  fi
}

export -f log_dbg

#######################################
# Arguments:
# - str
# Outputs:
# - Writes underlined str to stdout
#######################################
function print_underlined()
{
  printf "$1\n"
  printf -- "-%.0s" $(seq 0 $(expr ${#1} - 1))
  printf "\n"
}

export -f print_underlined


# Utils
# -----------------------------------------------------------------------------
#######################################
# Get array value
# Arguments:
# - array       : Target array
# - int         : Value index
# Outputs
# - Writes value to stdout
#######################################
get_array_value()
{
  local -r arr=("${!1}")
  local -r idx="$2"
  printf "${arr[$idx]}"
}

export -f get_array_value

#######################################
# Check if a value in an array
# Arguments:
# - array       : Target array
# - value       : Value
# Returns true if value in array
#######################################
is_value_in_array()
{
  local -r arr=("${!1}")
  local -r val="$2"

  for v in "${arr[@]}"; do
    if [[ "${v}" == "${val}" ]]; then
      return 0
    fi
  done

  return 1
}

export -f is_value_in_array

#######################################
# Get a cfg file value from a key
# Arguments:
# - str         : Key
# - str         : File path
# Outputs
# - Writes value to stdout
#######################################
function get_cfg_file_value_from_key()
{
  sed -rn "s/^${0}=([^\n]+)$/\1/p" "${1}"
}

export -f get_cfg_file_value_from_key

#######################################
# Update a cfg file key value, or append if it doesn't exists
# Arguments:
# - str         : File path
# - str         : Target key
# - str         : Value
# - str (opt.)  : Separator, default: '='
#######################################
function set_cfg_file_key_value()
{
  local -r file="$1"
  local -r key="$2"
  local -r value="$3"
  [[ $# -eq 4 ]] && local -r sep="$4" || local -r sep="="

  if ! grep -R "^[#]*\s*${key}${sep}.*" "${file}" 1>/dev/null; then
    # Key not found, append:
    printf "${key}${sep}${value}" >> "${file}"
  else
    # Update key
    sudo sed -ir "s|^[#]*\s*${key}${sep}.*|${key}${sep}${value}|" "${file}"
  fi
}

export -f set_cfg_file_key_value

#######################################
# Look for a package manager and install given packages with it
# Arguments:
# - array str   : Packages
#######################################
function install_packages()
{
  if [[ -x "$(command -v apk)" ]]; then
    sudo apk add --no-cache $@ &>/dev/null
  elif [[ -x "$(command -v apt)" ]]; then
    sudo apt install -yq $@ &>/dev/null
  elif [[ -x "$(command -v dnf)" ]]; then
    sudo dnf install -yq --skip-broken $@ &>/dev/null
  elif [[ -x "$(command -v yum)" ]]; then
    sudo yum install -y --skip-broken $@ &>/dev/null
  elif [[ -x "$(command -v pacman)" ]]; then
    sudo pacman --noconfirm -S $@ &>/dev/null
  else
    printf "[ERR]: Package manager not found.\n" >&2
    return 1
  fi
}

export -f install_packages

#######################################
# Add given cronjob
# Arguments:
# - str         : Cron job
# Example:
# - add_cronjob "* * * * * ls /"
# Outputs:
# - Write to stdout packages as they're installed
#######################################
function add_cronjob()
{
  local -r tmp_file="/tmp/crontab_bkp"
  crontab -l 1>$tmp_file 2>/dev/null || true # Ignore error if no previous jobs
  printf "$1\n" >> $tmp_file
  crontab $tmp_file
  if [ -f $tmp_file ]; then
    rm $tmp_file
  fi
}

export -f add_cronjob

#######################################
# Delete duplicate iptable rules
#######################################
function delete_duplicate_iptables_rules()
{
  local -r tmp_file="/tmp/iptables.conf"
  sudo iptables-save | awk '/^COMMIT$/ { delete x; }; !x[$0]++' > $tmp_file
  sudo iptables -F
  sudo iptables-restore < $tmp_file
  if [ -f $tmp_file ]; then
    rm $tmp_file
  fi
}

export -f delete_duplicate_iptables_rules

#######################################
# Add font
# Arguments
# - str         : Font location
#######################################
function add_font()
{
  local -r fonts_path=~/.local/share/fonts/
  mkdir -p $fonts_path
  cp "$1" $fonts_path
}

export -f add_font

#######################################
# Check if a command exist
# Arguments
# - cmd         : Command to check
#######################################
function is_cmd_set()
{
  if ! type "$1" &>/dev/null; then
    printf "[ERR]: command not found: $1\n" >&2
    return 1
  fi
  return 0
}

export -f is_cmd_set
