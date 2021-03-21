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
Add your newly installed computer's public [ssh key to Github].

[ssh key to Github]: https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account

#### Arch Linux

```zsh
$ yay -Syu alacritty curl sway yadm-git waybar wofi
```

#### Ubuntu & Debian

Debian and Ubuntu does not provide all dependencies needed in the official repositories unfortunately.

```zsh
$ sudo apt update -y && sudo apt install -y curl yadm
```

#### Initialize

Install dotfiles.

```zsh
yadm clone git@github.com:AntonFriberg/dotfiles.git
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
