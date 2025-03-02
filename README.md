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
│   │   ├── .zshrc-full
│   │   └── foot.ini
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

##### Scripts

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

##### Resources
- (fonts) [g: githubnext/monaspace](https://github.com/githubnext/monaspace)
- (fonts) [g: ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts)
- (win) [g: microsoft/PowerToys](https://github.com/microsoft/PowerToys)

<br />

##### VSCode
- (commands) <kbd>ctrl</kbd> + <kbd>shift</kbd> + <kbd>p</kbd>
  - (theme) Developer: Inspect Editor Tokens and Scopes

<br />

##### Windows Terminal
- [JSON Fragments](https://learn.microsoft.com/en-us/windows/terminal/json-fragment-extensions)
  - can be used to set user profiles and color schemes
  - autodetect, place .json files in (install dependent):
    - sys: `%PROGRAMDATA%/Microsoft/Windows Terminal/Fragments`
    - usr: `%LOCALAPPDATA%/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/Fragments`
  - merge with setting.json,
    - conflicts: overwrites settings with the last loaded fragment
- Example profile (to generate guid, pwsh: `[guid]::NewGuid().Guid`)

```json
{
  "commandline": "{path_to_msys64}/msys2_shell.cmd -defterm -here -no-start -mingw64",
  "icon": "{path_to_msys64}/mingw64.ico",
  "guid": "{ab7cd0fd-98b4-485e-9271-50384fc29306}",
  "hidden": false,
  "name": "MSYS2/MINGW64",
  "startingDirectory": "{path_to_msys64}/home/%USERNAME%"
}
```

<br />
