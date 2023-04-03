### cfg
---
- Config scripts, dotfiles, ...

```ts
├── bin/
│   ├── conf/
│   │   ├── dhcpcd_routed_ap.conf
│   │   ├── dnsmasq_routed_ap.conf
│   │   ├── hostapd_routed_ap.conf
│   │   └── sysctl_routed_ap.conf
│   ├── dotfiles/
│   │   ├── tmux/
│   │   ├── .p10k.zsh
│   │   ├── .vimrc
│   │   ├── .vimrc-full
│   │   ├── .zshrc
│   │   └── .zshrc-full
│   ├── fonts/
│   │   msft/
│   │   ├── settings_vscode.json
│   │   └── settings_windows_terminal.json
│   └── obsidian/
├── README.md
└── src/
    ├── set_base_packages.sh
    ├── set_routed_wap.sh
    ├── set_ssh_server.sh
    └── utils.sh
```

<br />

### Scripts
---

<br />

*./src/set_base_packages.sh*
- Set fonts, configs and packages

<br />

*./src/set_routed_wap.sh*
- Set a Wireless Access Point routing to eth0 using IP masquerading
- If RPi, set localisation with:

```sh
sudo raspi-config  # - Localisation Options -> WLAN Country
```

<br />

*./src/set_ssh_server.sh*
- Set secured SSH server

<br />
