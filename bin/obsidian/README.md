### Obsidian.md
---

##### Setup
- Releases: [g: obsidianmd/obsidian-releases](https://github.com/obsidianmd/obsidian-releases/releases/)

```sh
# Linux
# - <https://github.com/tchx84/Flatseal>
# - <https://flathub.org/apps/details/md.obsidian.Obsidian>
flatpak install flathub com.github.tchx84.Flatseal
flatpak install flathub md.obsidian.Obsidian
flatpak run com.github.tchx84.Flatseal
# Remove unneeded permissions, ex: Network, PulseAudio, Secure Shell agent
# From the docs: GPU acceleration can be disabled if necessary
flatpak run md.obsidian.Obsidian
```

<br />

##### Shortcuts
- <kbd>ctrl</kbd> + <kbd>,</kbd> : open settings
- <kbd>ctrl</kbd> + <kbd>p</kbd> : open command palette
- <kbd>ctrl</kbd> + <kbd>o</kbd> : open quich switch
- <kbd>ctrl</kbd> + <kbd>left click</kbd> : open in new tab
- <kbd>ctrl</kbd> + <kbd>n</kbd> : create new note
- <kbd>ctrl</kbd> + <kbd>shift</kbd> + <kbd>n</kbd> : create new note right
- <kbd>ctrl</kbd> + <kbd>t</kbd> : open new tab
- <kbd>ctrl</kbd> + <kbd>shift</kbd> + <kbd>t</kbd> : reopen closed tab
- <kbd>ctrl</kbd> + <kbd>w</kbd> : close tab
- <kbd>ctrl</kbd> + <kbd>shift</kbd> + <kbd>w</kbd> : close window
- <kbd>ctrl</kbd> + <kbd>e</kbd> : toggle reading view (useful to move view)
- <kbd>ctrl</kbd> + <kbd>f</kbd> : search in file
- <kbd>ctrl</kbd> + <kbd>shift</kbd> + <kbd>f</kbd> : search in all files
- <kbd>ctrl</kbd> + <kbd>((page-up | page-down) | nb)</kbd> : switch tab
- Custom:
  - <kbd>ctrl</kbd> + <kbd>shift</kbd> + <kbd>(↑ | ↓ | page-up | page-down)</kbd> : switch tab group
  - <kbd>ctrl</kbd> + <kbd>shift</kbd> + <kbd>e</kbd> : show File Explorer
  - <kbd>ctrl</kbd> + <kbd>shift</kbd> + <kbd>o</kbd> : show Outline
  - <kbd>ctrl</kbd> + <kbd>b</kbd> : (rm conflict: *Toggle bold*) Toggle right sidebar

<br />

##### Usage
- Display images: `![({name})|({width})]({filepath})`
- Tag (for searches, graph view): #tag, #tag/nested, or at the top of a file:

```yaml
---
tags:
  - tag
  - tag/nested
---
```

<br />

##### Obsidian files
- System wide
  - lin: */home/{uid}/.config/Obsidian/*
  - win: *%APPDATA%\Obsidian*
  - mac: */Users/{uid}/Library/Application Support/obsidian*
- Per vault: *.obsidian* (cfg, hotkeys, plugins, css, ...)
  - *.obsidian/workspace* stores panes and opened files (opt. *.gitignore*)
  - *.obsidian/snippets/*
    - Css files, can individually be enabled/disabled in Settings
      - *.obsidian/appearance.json["enabledCssSnippets"]/*

<br />

##### Resources
- [d: obsidian](<https://help.obsidian.md/Obsidian/Index>)
  - [/customizing-css](<https://help.obsidian.md/Advanced+topics/Customizing+CSS>) ([snippets](<https://github.com/Dmytro-Shulha/obsidian-css-snippets/tree/master/Snippets>))
  - [/style-guide](<https://help.obsidian.md/Contributing+to+Obsidian/Style+guide>)
  - [/tags](<https://help.obsidian.md/How+to/Working+with+tags>)
  - [/yaml](<https://help.obsidian.md/Advanced+topics/YAML+front+matter>)
- Community
  - [g: kmaasrud/awesome-obsidian](<https://github.com/kmaasrud/awesome-obsidian>)
  - [f: themes showcase](<https://forum.obsidian.md/t/meta-post-css-themes-showcase/76/1>)
- [Markdown syntax](<https://www.markdownguide.org/cheat-sheet/>)
- [A closer look at Obsidian’s innovative graph view](<https://mindmappingsoftwareblog.com/obsidian-graph-view/>)
- Css:
  - [Align content left with *Readable line length*](<https://forum.obsidian.md/t/large-margin-on-the-left-side-of-the-text-how-to-make-it-narrower/3265/8>) (settings.editor)
  - Todo
    - [ ] Word wrap
    - [ ] Ruler at 80 characters, or column count in status bar

<br />
