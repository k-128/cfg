#!/usr/bin/env bash
#
# Set base packages, fonts and configs

set -o errexit   # Exit if non-zero exit code, ...
set -o nounset   # Exit if unset variables, ...
set -o pipefail  # Exit if non-zero exit code, ...

readonly SCRIPT_NAME="${0##*/}"
readonly PATH_DIR=$(dirname $(readlink -f $0))
readonly PATH_FILES="${PATH_DIR}/../bin/dotfiles"
readonly PATH_FONTS="${PATH_DIR}/../bin/fonts"

source "${PATH_DIR}/utils.sh"
LOG_LVL=1

readonly REQ_PKGS=(
  zsh zsh-syntax-highlighting zsh-autosuggestions git vim tmux rsync htop btop)
readonly GIT_P10K="https://github.com/romkatv/powerlevel10k.git"
readonly GIT_RAW="https://raw.githubusercontent.com"
readonly GIT_VIMPLUG="${GIT_RAW}/junegunn/vim-plug/master/plug.vim"


function display_help()
{
  printf "\n"
  print_underlined "Help"
  printf "Set base packages, fonts and configs.\n"
  printf "\n"
  printf "Packages: ${REQ_PKGS[*]}\n"
  printf "\n"
  printf "Options:\n"
  printf "\t-h \tDisplay this help message.\n"
  printf "\t-v \tMore verbose output\n"
  printf "\n"
}


function main()
{
  # cfg.
  # ---------------------------------------------------------------------------
  local OPTIND=1  # Reset getopts OPTIND
  while getopts ":hv" flag; do
    case "${flag}" in
      h)
        display_help
        exit 0
        ;;
      v)
        LOG_LVL=2
        log_dbg "Script path: ${PATH_DIR}/${SCRIPT_NAME}"
        ;;
      *)
        printf "Unsupported option: ${flag}\n\n"
        display_help
        exit 1
        ;;
    esac
  done

  # exec.
  # ---------------------------------------------------------------------------
  printf "\n"
  print_underlined "Setting base packages, fonts and configs..."
  log_inf "Installing ${REQ_PKGS[*]}"
  install_packages ${REQ_PKGS[@]} || true # Ignore error if missing package

  log_inf "Adding fonts..."
  add_font "${PATH_FONTS}/Fira Code Regular Nerd Font Complete Mono.ttf"
  add_font "${PATH_FONTS}/Fira Mono Regular Nerd Font Complete Mono.otf"
  add_font "${PATH_FONTS}/Roboto Mono Nerd Font Complete Mono.ttf"

  log_inf "Configuring tmux..."
  cp "${PATH_FILES}/.tmux.conf" ~/

  log_inf "Configuring vim..."
  cp "${PATH_FILES}/.vimrc" ~/
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs $GIT_VIMPLUG &>/dev/null

  log_inf "Configuring zsh..."
  git clone --depth=1 $GIT_P10K ~/powerlevel10k &>/dev/null || true
  cp "${PATH_FILES}/.p10k.zsh" ~/
  cp "${PATH_FILES}/.zshrc" ~/

  log_inf "Configuring git..."
  git config --global alias.s status
  git config --global alias.logf "log --pretty=format:'%C(auto)%h %ad %cn %s' --graph"

  log_inf "Base packages set:"
  log_inf "- To set zsh as default shell, run: chsh -s $(which zsh)"
  log_inf "- To reconfigure powerlevel10k, run: p10k configure"
  log_inf "- To set vim plugs, start vim and call: :PlugInstall"
}

main "$@"
