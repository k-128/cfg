#!/usr/bin/env bash
#
# Set a Wireless Access Point routing to eth0 using IP masquerading

set -o errexit   # Exit if non-zero exit code, ...
set -o nounset   # Exit if unset variables, ...
set -o pipefail  # Exit if non-zero exit code, ...

readonly SCRIPT_NAME="${0##*/}"
readonly PATH_DIR=$(dirname $(readlink -f $0))
readonly PATH_FILES="${PATH_DIR}/../bin/conf"

source "${PATH_DIR}/utils.sh"
LOG_LVL=1

readonly REQ_PKGS=(hostapd dhcpcd5 dnsmasq iptables)
readonly GIT_RAW="https://raw.githubusercontent.com"
readonly GIT_DHCPCD="${GIT_RAW}/NetworkConfiguration/dhcpcd/master"
readonly GIT_DNSMASQ="${GIT_RAW}/imp/dnsmasq/master"


function display_help()
{
  printf "\n"
  print_underlined "Help"
  printf "Set a Wireless Access Point routing to eth0 using IP masquerading.\n"
  printf "\n"
  printf "Options:\n"
  printf "\t-h \t\tDisplay this help message.\n"
  printf "\t-v \t\tMore verbose output\n"
  printf "\t-s \"ssid\"\tAccess Point SSID\n"
  printf "\t-p \"password\"\tAccess Point password\n"
  printf "\t-c \"CC\"\t\tWLAN Country Code\n"
  printf "\n"
  print_underlined "Examples"
  printf "./${SCRIPT_NAME}\n"
  printf "./${SCRIPT_NAME} -v\n"
  printf "./${SCRIPT_NAME} -s \"Access Point 1\" -p \"123456\" -c \"CH\"\n"
  printf "./${SCRIPT_NAME} -s \"Access Point 1\" -c \"RU\"\n"
  printf "\n"
  print_underlined "Warning"
  printf "This script overwrites:\n"
  printf "+ /etc/dhcpcd.conf\n"
  printf "+ /etc/dhcpcd.conf.orig\n"
  printf "+ /etc/dnsmasq.conf\n"
  printf "+ /etc/dnsmasq.conf.orig\n"
  printf ".orig files downloaded directly from respective gits default conf.\n"
  printf "This script removes duplicate iptables rules.\n"
  printf "If needed, do the required backups before running.\n"
  printf "\n"
}


function main()
{
  # cfg.
  # ---------------------------------------------------------------------------
  local ap_ssid=""
  local ap_password=""
  local ap_country_code=""

  local OPTIND=1  # Reset getopts OPTIND
  while getopts ":hvs:p:c:" flag; do
    case "${flag}" in
      h)
        display_help
        exit 0
        ;;
      v)
        LOG_LVL=2
        log_dbg "Script path: ${PATH_DIR}/${SCRIPT_NAME}"
        ;;
      s) ap_ssid="${OPTARG}" ;;
      p) ap_password="${OPTARG}" ;;
      c) ap_country_code="${OPTARG}" ;;
      *)
        printf "Unsupported option: ${flag}\n\n"
        display_help
        exit 1
        ;;
    esac
  done

  if [[ -z $ap_ssid ]]; then
    read -p "Enter AP SSID:`echo $'\n> '`" ap_ssid
  fi

  if [[ -z $ap_password ]]; then
    read -sp "Enter AP password:`printf $'\n> '`" ap_password; echo ""
  fi

  if [[ -z $ap_country_code ]]; then
    read -p "Enter AP country code:`printf $'\n> '`" ap_country_code
  fi

  # exec.
  # ---------------------------------------------------------------------------
  printf "\n"
  print_underlined "Setting up routed WAP..."
  log_inf "Installing ${REQ_PKGS[*]}"
  install_packages ${REQ_PKGS[@]}

  log_inf "Configuring hostapd..."
  sudo cp "${PATH_FILES}/hostapd_routed_ap.conf" /etc/hostapd/
  hostapd_conf="/etc/hostapd/hostapd_routed_ap.conf"
  set_cfg_file_key_value "${hostapd_conf}" ssid "$ap_ssid"
  set_cfg_file_key_value "${hostapd_conf}" wpa_passphrase "$ap_password"
  set_cfg_file_key_value "${hostapd_conf}" country_code "$ap_country_code"
  set_cfg_file_key_value /etc/default/hostapd DAEMON_CONF "\"${hostapd_conf}\""

  log_inf "Configuring dhcpcd..."
  sudo wget -qO /etc/dhcpcd.conf.orig "${GIT_DHCPCD}/src/dhcpcd.conf"
  sudo cp "${PATH_FILES}/dhcpcd_routed_ap.conf" /etc/dhcpcd.conf

  log_inf "Configuring dnsmasq..."
  sudo wget -qO /etc/dnsmasq.conf.orig "${GIT_DNSMASQ}/dnsmasq.conf.example"
  sudo cp "${PATH_FILES}/dnsmasq_routed_ap.conf" /etc/dnsmasq.conf

  log_inf "Configuring routing..."
  # Enable ipv4 forwarding
  sudo cp "${PATH_FILES}/sysctl_routed_ap.conf" /etc/sysctl.d/routed-ap.conf
  sudo sysctl -w net.ipv4.ip_forward=1 1> /dev/null

  # Add outbound traffic IP masquerading on eth0, save and load rule @boot
  sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  delete_duplicate_iptables_rules
  sudo iptables-save | sudo tee /etc/iptables_routed_ap.conf 1> /dev/null
  add_cronjob "@reboot sudo iptables-restore < /etc/iptables_routed_ap.conf"

  log_inf "Starting services..."
  sudo service dhcpcd restart &> /dev/null
  sudo systemctl enable dnsmasq &> /dev/null
  sudo service dnsmasq restart &> /dev/null
  sudo systemctl unmask hostapd &> /dev/null
  sudo systemctl enable hostapd &> /dev/null
  sudo service hostapd restart &> /dev/null

  log_inf "Routed WAP set:"
  log_inf "- SSID: ${ap_ssid}"
  log_inf "- Router's IP: 192.168.4.1/24, to edit: /etc/dhcpcd.conf"
  log_inf "- Listening interface: wlan0, to edit: /etc/dnsmasq.conf"
  log_inf "- Routes to eth0 using IP masquerading, to edit: iptables"
}

main "$@"
