# AntonFriberg's Dotfiles

My personal dotfiles manging packages, scripts and configuration on [Ubuntu],
[Debian] and [Arch Linux]. Managed by [Home Manager] utilizing [Nix].

- Color Scheme: [Nord]
- Wallpaper: [Published on Unsplash]
- Terminal: [Alacritty]
- Editor: [Visual Studio Code]

[Ubuntu]: https://ubuntu.com/
[Debian]: https://www.debian.org/
[Arch Linux]: https://archlinux.org/
[Home Manager]: https://github.com/nix-community/home-manager
[Nix]: https://github.com/NixOS/nixpkgs
[Alacritty]: https://github.com/alacritty/alacritty
[Nord]: https://github.com/nordtheme/nord
[Visual Studio Code]: https://github.com/microsoft/vscode

## Screenshots

Currently I have no screenshots since I am working on the Hyprland
configurations.

### Wallpaper
Wallpaper [published on Unsplash] which grants you an irrevocable, nonexclusive, worldwide copyright license to download, copy, modify, distribute, perform, and use images from Unsplash for free. See [Unsplash license] for more info.

## Installation & Management

### History

I originally used a simple solution to keep my dotfiles under version control
which I found on the [Atlassian developer blog]. This technique is great since according to comments requires:

> No extra tooling, no symlinks, files are tracked on a version control system,
  you can use different branches for different computers, you can replicate you configuration easily on new installation.

Later, I found [yadm], Yet Another Dotfiles Manager, which embraces
the same underlying idea but adds a user-friendly interface and tooling.

Currently, I am experimenting with a much more advanced setup using
[Home Manager] and [Nix] to not only manage my dotfiles but basically the entire
user environment. This means the package installation, fonts, window managers,
configurations, user services, and much more.

[atlassian developer blog]: https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
[yadm]: https://github.com/TheLocehiliosan/yadm

### Installation

Install Nix package manager using the [Determinate Nix Installer]

```sh
curl -L https://install.determinate.systems/nix | sh -s -- install
```

Install Home-Manager and swith to this repos configuration.

```sh
$ nix run "nixpkgs#home-manager" -- switch --flake github:antonfriberg/dotfiles
```

That is it. If the system and user is matching any available setup it will
install everything for you.

[Determinate Nix Installer]: https://determinate.systems/posts/determinate-nix-installer/

### Troubleshooting

- **No prompt in fish after initial startup? Run the following.**

  ```fish
  tide configure --auto --style=Lean --prompt_colors='16 colors' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Compact --icons='Many icons' --transient=No
  ```

- **Unable to start Nix applications due to errors such as `user: unknown userid 11789`**

  This happened on work computers after they were omborded with Red Hat IdM. I found two possible
  solutions.

  1. Specify path to shared library for libnss for nix program
      ```sh
      $ LD_PRELOAD="/lib/x86_64-linux-gnu/libnss_sss.so.2" <nix program>
      ```
  2. Install Name Service Cache Daemon (nscd)
      ```sh
      # For Debian/Ubuntu
      $ sudo apt install nscd
      ```

- **Unable to start Electron apps such as Chrome, Visual Studio Code, etc from Nix
  on Ubuntu 24 due to sandbox errors?**

  This is due security changes in AppArmor on Ubuntu 24.
  See https://github.com/NixOS/nixpkgs/issues/121694#issuecomment-2159420924

  Current workaround is to disable the restriction. This can be done for the current
  session with the following command.

  ```fish
  echo 0 | sudo tee /proc/sys/kernel/apparmor_restrict_unprivileged_userns
  ```

  Or perminently by editing the file `/etc/sysctl.d/60-apparmor-namespace.conf`

  ```conf
  # Workaround for Electron apps from nixpkgs
  kernel.apparmor_restrict_unprivileged_userns=0
  ```

- **Different cursor or blurry rendering in Electron apps?**

  This is due to apps running in XWayland instead of native Wayland rendering.
  Starting the application with extra command arguments forces native wayland.

  ```
  --enable-features=UseOzonePlatform
  --enable-features=WaylandWindowDecoration
  --ozone-platform=wayland
  ```

  If staring the application in Gnome it can be tricky to get the arguments into
  the application. The easiest is probably to simply copy the desktop file from
  `~/.nix-profile/share/applications` to `~/.local/share/applications` and edit
  the `Exec=` line.

  ```sh
  $ diff ~/.nix-profile/share/applications/spotify.desktop ~/.local/share/applications/spotify.desktop
  < Exec=spotify %U
  ---
  > Exec=spotify --enable-features=UseOzonePlatform --enable-features=WaylandWindowDecoration --ozone-platform=wayland  %U
  ```

## Python & Javascript Development

I prefer to keep Python and Javascript development environments outside of Nix
due to some issues I have experienced and known performance issues due to the
reproducible builds in Nix. Instead I install these via [Mise-en-Place] tool.

[Mise-en-Place] is installed using Nix as usual and configured in `modules/terminal/mise.nix`. Here I specify which tools I want access to globally.

```nix
{...}: {
  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    globalConfig = {
      tools = {
        python = "3.12";
        node = "20";
      };
    };
  };
}
```

After activating my home-manager environment I have access to `mise` and can
run the following to install python and nodejs.

```sh
# Check that mise is installed
❯ mise --version
2024.5.9 linux-x64 (2024-08-12)
# Install configured global tools
❯ mise install
mise node@20.17.0 ✓ installed
mise python@3.12.5 ✓ installed
# Check that it is working
❯ python --version && which python
Python 3.12.5
/home/antonfr/.local/share/mise/installs/python/3.12/bin/python
❯ node --version && which node
v20.17.0
/home/antonfr/.local/share/mise/installs/node/20/bin/node
```

For local development where I might want different versions of Python or NodeJS
I utilize a project specific `.mise.toml` file.

```toml
[tools]
python = "3.10"

[env]
_.python.venv = { path = ".venv", create = true }
```

Then it works like this.

```sh
# Trust the .mise.toml file in the project dir
❯ mise trust project-dir/.mise.toml
# Navigate into the project dir which triggers mise hook
❯ cd project-dir/
mise missing: python@3.10.14
# Mise alerts that tools are missing from installation
❯ mise install
mise python@3.10.14 ✓ installed                                              mise creating venv at: ~/project-dir/.venv
# Mise installs Python version and activates our virtualenv
❯ python --version & which python & which pip
Python 3.10.14
/home/antonfr/project-dir/.venv/bin/python
/home/antonfr/project-dir/.venv/bin/pip
```

This means that I can quickly switch between different project specific tool
versions by simply navigating into them.

[Mise-en-Place]: https://mise.jdx.dev/

## Uninstall

This is one of best features of Nix and it extends to Home-Manager as well. To
uninstall we basically only need to do

```bash
$ sudo rm -rf /nix
```

That is it.

However, there will be some stuff left over such as groups, temporary files,
shell profile configurations, and other minor stuff. A better way to uninstall
Nix is to use the Determinate Installer that I recommend you use to install
Nix.

```bash
$ /nix/nix-installer uninstall
Nix uninstall plan (v0.27.0)

Planner: linux

Configured settings:
* nix_build_group_id: 30001

Planned actions:
* Remove upstream Nix daemon service
* Remove the directory `/etc/tmpfiles.d` if no other contents exists
* Unconfigure the shell profiles
* Remove the Nix configuration in `/etc/nix/nix.conf`
* Unset the default Nix profile
* Remove Nix users and group
* Remove the directory tree in `/nix`
* Remove the directory `/nix`


Proceed? ([Y]es/[n]o/[e]xplain):
```

This removes everything **properly**, including all files created in home
catalog by Home Manager! Full cleanup of your configurations and the
applications themselves in a single command!

This works due to how Nix works which Home-Manager utilizes.

Home-Manager does not place any configuration files in your home catalog.
Instead, it creates symlinks which reference generated files on a path unique
to the current iteration of inputs. So if any dependency or configuration
changes the generated files will be placed under a new directory. This makes
it really easy to revert a change by going back to the previous
generation, as seen the [Rollbacks section of the documentation].

So if we look at a generated configuration file.

```bash
$ ls -al
lrwxrwxrwx 1 antonfr antonfr 81 Oct 28 21:40 /home/antonfr/.config/git/config -> /nix/store/x3r12ppqhjgzdv2jx63cjflfc10qjn5b-home-manager-files/.config/git/config
```

We see that the contents are actually under /nix so once /nix is removed with
the uninstaller it also removes all references to /nix. Removing everything
neatly and without issues.

It does not remove local state, cache or temporary files which are unique for
each application and version. This is left up to the user. But this fact
also allows us to do something pretty nifty.

```
# Uninstall everything
$ /nix/nix-installer uninstall
# Reinstall Nix
$ curl -L https://install.determinate.systems/nix | sh -s -- install
# Recreate the entire setup back again
$ nix run "nixpkgs#home-manager" -- switch --flake github:antonfriberg/dotfiles
```

The above makes it pretty fool-proof if you ever manage to break Nix or
Home-Manager setup in any way. Simply tear everything down and recreate it.

[Rollbacks section of the documentation]:https://nix-community.github.io/home-manager/index.xhtml#sec-usage-rollbacks
