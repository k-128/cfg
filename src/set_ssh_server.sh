#!/usr/bin/env bash
#
# Set secured SSH server

set -o errexit   # Exit if non-zero exit code, ...
set -o nounset   # Exit if unset variables, ...
set -o pipefail  # Exit if non-zero exit code, ...

readonly SCRIPT_NAME="${0##*/}"
readonly PATH_DIR=$(dirname $(readlink -f $0))
readonly PATH_FILES="${PATH_DIR}/../bin/dotfiles"
readonly PATH_FONTS="${PATH_DIR}/../bin/fonts"

source "${PATH_DIR}/utils.sh"
LOG_LVL=1


function display_help()
{
  printf "\n"
  print_underlined "Help"
  printf "Set secured SSH server\n"
  printf "\n"
  printf "Config:\n"
  printf "+ PermitRootLogin no\n"
  printf "+ PubkeyAuthentication yes\n"
  printf "+ PasswordAuthentication no\n"
  printf "\n"
  printf "At least one authorized public key is required, gen. examples:\n"
  printf "  ssh-keygen -t rsa -b 4096 -C \"msg\".\n"
  printf "  ssh-keygen -t ed25519 -C \"msg\".\n"
  printf "\n"
  printf "Options:\n"
  printf "\t-h \tDisplay this help message.\n"
  printf "\t-v \tMore verbose output\n"
  printf "\t-p \tCustom port\n"
  printf "\t-k \tAuthorized public key\n"
  printf "\n"
  print_underlined "Examples"
  printf "./${SCRIPT_NAME}\n"
  printf "./${SCRIPT_NAME} -v\n"
  printf "./${SCRIPT_NAME} -p 1337\n"
  printf "./${SCRIPT_NAME} -k \"pubkey 1\" -k \"pubkey 2\" -k \"pubkey 3\"\n"
  printf "\n"
}


function main()
{
  # cfg.
  # ---------------------------------------------------------------------------
  local custom_port
  local pub_keys=()

  local OPTIND=1  # Reset getopts OPTIND
  while getopts ":hvp:k:" flag; do
    case "${flag}" in
      h)
        display_help
        exit 0
        ;;
      v)
        LOG_LVL=2
        log_dbg "Script path: ${PATH_DIR}/${SCRIPT_NAME}"
        ;;
      p) custom_port="${OPTARG}" ;;
      k) pub_keys+=("${OPTARG}") ;;
      *)
        printf "Unsupported option: ${flag}\n\n"
        display_help
        exit 1
        ;;
    esac
  done

  if [[ "${#pub_keys[@]}" == 0 ]]; then
    # No authorized public key declared, ask for one:
    read -p "Enter authorized public key:`printf $'\n> '`" pk
    pub_keys+=("${pk}")
  fi

  # exec.
  # ---------------------------------------------------------------------------
  printf "\n"
  print_underlined "Setting up secured SSH server"
  install_packages openssh-server

  log_inf "Configuring ssh daemon..."
  set_cfg_file_key_value /etc/ssh/sshd_config "PermitRootLogin" "no" " "
  set_cfg_file_key_value /etc/ssh/sshd_config "PubkeyAuthentication" "yes" " "
  set_cfg_file_key_value /etc/ssh/sshd_config "PasswordAuthentication" "no" " "

  log_dbg "Adding authorized public key(s)\n"
  mkdir -p ~/.ssh
  touch ~/.ssh/authorized_keys
  chmod 700 ~/.ssh                  # Read, Write, Execute
  chmod 600 ~/.ssh/authorized_keys  # Read, Write
  for k in "${pub_keys[@]}"; do
    printf "$k\n" | sudo tee -a ~/.ssh/authorized_keys >/dev/null
  done

  if [[ ! -z "${custom_port}" ]]; then
    log_dbg "Setting custom port\n"
    set_cfg_file_key_value /etc/ssh/sshd_config "Port" "${custom_port}" " "
  fi

  log_inf "SSH Server set:"
  if [[ ! -z "${custom_port}" ]]; then
    log_inf "- Port: ${custom_port}"
  fi
  log_inf "- Authorized public key(s):"
  for k in "${pub_keys[@]}"; do
    log_inf "  ${k}"
  done
  log_inf "- To test the validity of the config: sudo sshd -t"
  log_inf "- For the config to directly take effect, either:"
  log_inf "  sudo kill -SIGHUP \$(pgrep -f \"sshd -D\")"
  log_inf "  or"
  log_inf "  sudo systemctl reload sshd"
}

main "$@"
