# AntonFriberg's Dotfiles

My personal configuration files and scripts used under both Arch Linux, Ubuntu
and Debian machines. Currently running [sway] window manager with [waybar],
[wofi] application launcher, and [alacritty] terminal. Utilizes [Zinit] for
Zsh plugin management and binary utilities installation.

Based on the [nord colorscheme] and managed by [yadm].

[sway]: https://github.com/swaywm/sway
[waybar]: https://github.com/Alexays/Waybar
[wofi]: https://github.com/mikn/wofi
[alacritty]: https://github.com/alacritty/alacritty
[nord colorscheme]: https://github.com/arcticicestudio/nord
[yadm]: https://github.com/TheLocehiliosan/yadm
[zinit]: https://github.com/zdharma/zinit

## Screenshots
### Wallpaper
[Wallpaper published on Unsplash] which grants you an irrevocable, nonexclusive, worldwide copyright license to download, copy, modify, distribute, perform, and use images from Unsplash for free. See [Unsplash license] for more info.

[wallpaper published on unsplash]: https://unsplash.com/photos/snow-covered-mountain-under-white-clouds-id_Rjz1bsoI
[unsplash license]: https://unsplash.com/license
### Clean
![Clean](.config/yadm/screenshots/clean.png)
### Dirty
![Dirty](.config/yadm/screenshots/dirty.png)
### Editor
![Editor](.config/yadm/screenshots/editor.png)


## Dotfile Installation & Management

### History

I previously used a simple solution to keep my dotfiles under version control
which I found on the [Atlassian developer blog]. This technique is great since according to comments requires:

> No extra tooling, no symlinks, files are tracked on a version control system,
  you can use different branches for different computers, you can replicate you configuration easily on new installation.

However, recently I found [yadm], Yet Another Dotfiles Manager, which embraces
the same underlying idea but adds a user-friendly interface.

[atlassian developer blog]: https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

### Installation

First setup [GitHub CLI] and login.

```zsh
$ gh auth login
```

[GitHub CLI]: https://github.com/cli/cli/blob/trunk/docs/install_linux.md

#### Arch Linux

Install dependencies using yay or other AUR helper.

```zsh
$ yay -Syu alacritty zsh curl git sway yadm-git waybar wofi jq
```

#### Ubuntu & Debian

Debian and Ubuntu does not provide all dependencies needed in the official repositories unfortunately.

```zsh
$ sudo apt update -y && sudo apt install -y zsh curl git yadm jq
```

#### Initialize

Install dotfiles.

```zsh
yadm clone https://github.com/AntonFriberg/dotfiles.git
yadm decrypt
yadm bootstrap
```

### Dotfile Management

```zsh
# Display yadm’s manual.
man yadm
# Show the repository status
yadm status
# Add file to dotfile management
yadm add .Xresources
# Commit change
yadm commit -m "Add Xresources"
# Send commits to remote repository
yadm push
```
