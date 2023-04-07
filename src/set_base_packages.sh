#!/usr/bin/env bash
#
# Set base packages, fonts and configs

set -o errexit   # Exit if non-zero exit code, ...
set -o nounset   # Exit if unset variables, ...
set -o pipefail  # Exit if non-zero exit code, ...

readonly SCRIPT_NAME="${0##*/}"
readonly PATH_DIR=$(dirname $(readlink -f $0))
readonly PATH_FILES="${PATH_DIR}/../bin/dotfiles"
readonly PATH_FONTS="${PATH_DIR}/../bin/fonts/nix"

source "${PATH_DIR}/utils.sh"
LOG_LVL=1

readonly PKGS_REQ=(git vim tmux rsync htop curl)
readonly PKGS_ZSH=(zsh)
readonly URL_GITHUB_RAW="https://raw.githubusercontent.com"
readonly URL_VIM_PLUG="${URL_GITHUB_RAW}/junegunn/vim-plug/master/plug.vim"
readonly URL_TMUX_PLUG="https://github.com/tmux-plugins/tpm.git"
readonly URL_ZSH_AS="https://github.com/zsh-users/zsh-autosuggestions.git"
readonly URL_ZSH_SH="https://github.com/zsh-users/zsh-syntax-highlighting.git"
readonly URL_P10K="https://github.com/romkatv/powerlevel10k.git"
readonly COLORS=(red orange yellow green blue indigo violet grey)


function display_help()
{
  print_underlined "Help"
  printf "Set fonts, configs and packages (${PKGS_REQ[*]})\n"
  printf "Options:\n"
  printf "\t-h \t\tDisplay this help message.\n"
  printf "\t-v \t\tMore verbose output\n"
  printf "\t-z \t\tAdd: zsh, zsh-autosuggestions, zsh-syntax-highlighting\n"
  printf "\t-f \t\tFull, add:\n"
  printf "\t   \t\t- vim plugins\n"
  printf "\t   \t\t- zsh, zsh-autosuggestions, zsh-syntax-highlighting, p10k\n"
  printf "\t-t \t\tAdd tmux plugins: tpm, tmux-resurrect, tmux-continuum\n"
  printf "\t-c \"color\"\tTmux color, options (default: blue):\n"
  printf "\t   \t\t- ${COLORS[*]}"
  printf "\n"
}


function main()
{
  # cfg
  # ---------------------------------------------------------------------------
  local color="blue"
  local path_tmux_color="${PATH_FILES}/tmux/.tmux.blue.conf"
  local pkgs=("${PKGS_REQ[@]}")
  local is_full=""
  local is_tmux_plugins=""

  local OPTIND=1  # Reset getopts OPTIND
  while getopts ":hvzftc:" flag; do
    case "${flag}" in
      h)
        display_help
        exit 0
        ;;
      v)
        LOG_LVL=2
        log_dbg "Script location: ${PATH_DIR}/${SCRIPT_NAME}"
        ;;
      z) pkgs=("${PKGS_REQ[@]}" "${PKGS_ZSH[@]}") ;;
      f)
        pkgs=("${PKGS_REQ[@]}" "${PKGS_ZSH[@]}")
        is_full=1
        ;;
      t) is_tmux_plugins=1 ;;
      c) color="${OPTARG}" ;;
      *)
        log_err "Unsupported option: ${flag}\n"
        display_help
        exit 1
        ;;
    esac
  done

  if is_value_in_array COLORS[@] "${color}"; then
    path_tmux_color="${PATH_FILES}/tmux/.tmux.${color}.conf"
  else
    log_dbg "-c: Unsupported color: ${color}, using default: blue"
  fi

  # exec
  # ---------------------------------------------------------------------------
  print_underlined "Setting fonts, packages and configs"

  log_inf "Adding fonts..."
  for f in "${PATH_FONTS}"/*; do
    add_font "${f}"
  done

  log_inf "Installing: (${pkgs[*]})..."
  if ! install_packages ${pkgs[@]}; then
    log_err "Error(s) installing package(s)"
  fi

  log_inf "Checking & configuring packages..."
  for pkg in "${pkgs[@]}"; do
    case "${pkg}" in
      git)
        if is_cmd_set "git"; then
          log_inf "[x] git"
          git config --global alias.s status
          git config --global alias.logf \
            "log --pretty=format:'%C(auto)%h %ai %cn %s' --graph"
        else
          log_inf "[ ] git: not found"
        fi
        ;;
      vim)
        if is_cmd_set "vim"; then
          log_inf "[x] vim"

          if [[ -z "${is_full}" ]]; then
            cp "${PATH_FILES}/.vimrc" ~/
          else
            if is_cmd_set "curl"; then
              curl -fLo ~/.vim/autoload/plug.vim --create-dirs $URL_VIM_PLUG \
                &>/dev/null
              cp "${PATH_FILES}/.vimrc-full" ~/.vimrc
              log_inf "  + vim plugins set, to install, in vim: :PlugInstall"
            else
              cp "${PATH_FILES}/.vimrc" ~/
              log_inf "  + vim plugins not set: 'curl' not found (required)"
            fi
          fi
        else
          log_inf "[ ] vim: not found"
        fi
        ;;
      tmux)
        if is_cmd_set "tmux"; then
          log_inf "[x] tmux"
          cp "${PATH_FILES}/tmux/.tmux.conf" ~/
          cat $path_tmux_color >> ~/.tmux.conf

          if [[ -n "${is_tmux_plugins}" ]]; then
            if is_cmd_set "git"; then
              git clone --depth=1 $URL_TMUX_PLUG \
                ~/.tmux/plugins/tpm &>/dev/null || true
              cat "${PATH_FILES}/tmux/.tmux.plugins.conf" >> ~/.tmux.conf
              log_inf "  + tmux plugins set"
            else
              log_inf "  + tmux plugins not set: 'git' not found (required)"
            fi
          fi
        else
          log_inf "[ ] tmux: not found"
        fi
        ;;
      rsync)
        if is_cmd_set "rsync"; then
          log_inf "[x] rsync"
        else
          log_inf "[ ] rsync: not found"
        fi
        ;;
      htop)
        if is_cmd_set "htop"; then
          log_inf "[x] htop"
        else
          log_inf "[ ] htop: not found"
        fi
        ;;
      curl)
        if is_cmd_set "curl"; then
          log_inf "[x] curl"
        else
          log_inf "[ ] curl: not found"
        fi
        ;;
      zsh)
        if is_cmd_set "zsh"; then
          log_inf "[x] zsh"
          log_inf "  + to set as default shell: chsh -s /usr/bin/zsh"

          if is_cmd_set "git"; then
            git clone --depth=1 $URL_ZSH_AS \
              ~/.zsh/zsh-autosuggestions &>/dev/null || true
            log_inf "  + zsh-autosuggestions set"

            git clone --depth=1 $URL_ZSH_SH \
              ~/.zsh/zsh-syntax-highlighting &>/dev/null || true
            log_inf "  + zsh-syntax-highlighting set"

            if [[ -z "${is_full}" ]]; then
              cp "${PATH_FILES}/.zshrc" ~/
            else
              git clone --depth=1 $URL_P10K ~/powerlevel10k &>/dev/null || true
              cp "${PATH_FILES}/.zshrc-full" ~/.zshrc
              cp "${PATH_FILES}/.p10k.zsh" ~/
              log_inf "  + p10k set, to cfg: p10k configure"
            fi
          else
            cp "${PATH_FILES}/.zshrc" ~/
            log_inf "  + zsh plugins not set: 'git' not found (required)"
          fi
        else
          log_inf "[ ] zsh: not found"
        fi
        ;;
      *) log_dbg "Unexpected package: ${pkg}" ;;
    esac
  done

  log_inf "Done."
}

main "$@"
