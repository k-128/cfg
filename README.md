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
│   │   ├── Fira Code Regular Nerd Font Complete Mono.ttf
│   │   ├── Fira Code Regular Nerd Font Complete Mono Windows Compatible.ttf
│   │   ├── Fira Mono Regular Nerd Font Complete Mono.otf
│   │   ├── Fira Mono Regular Nerd Font Complete Mono Windows Compatible.otf
│   │   ├── Roboto Mono Nerd Font Complete Mono.ttf
│   │   ├── Roboto Mono Nerd Font Complete Mono Windows Compatible.ttf
│   │   ├── ShareTechMono-Regular.ttf
│   │   ├── SourceCodePro-Medium.ttf
│   │   ├── Terminess (TTF) Nerd Font Complete Mono Windows Compatible.ttf
│   │   └── Terminess (TTF) Nerd Font Complete Mono.ttf
│   └── msft/
│       ├── settings_vscode.json
│       └── settings_windows_terminal.json
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
- Set base packages, fonts and configs

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
