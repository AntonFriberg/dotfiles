# Home Manager Using Flake

The [Home Manager] project provides a basic system for managing a
user environment using the [Nix package manager] together with the
Nix libraries found in [Nixpkgs]. It allows declarative configuration
of user specific (non global) packages and dotfiles.

This [Home Manager] installation is managed using [Nix Flakes] instead
of the traditional [Nix Channels] method.

## Initial bring-up

If it is the first time you setup the `home-manager` installation using
flakes it can be a bit confusing since most guides reference the
traditional way using Nix channels instead and then later migrating it
into a flakes installation. This is not needed and you can actually
install `home-manager` directly using flakes. This is a minimal
reference on how I did it.

### Install Nix

Before you can install `home-manager` itself you will need to have a
working Nix installation. For this it is best to follow the offical
guide.

https://nixos.org/download.html#download-nix

You can verify that your Nix installation is working starting a new
nix shell with a minimal program present. This will not install
anything persistant on your system.

```
# Test working nix installation by starting a shell with hello present
$ hello
zsh: command not found: hello
# Start our nix shell test
$ nix-shell --packages hello
# Now our program is available
[nix-shell:~]$ hello
Hello, world!
# Seems to work so we simply exit the shell and get back to normal
[nix-shell:~]$ exit
```

### Enable experimental Nix Flakes support

Nix Flakes are still considered experimental. This does not mean that
they are not working correctly, it is simply that the CLI commands
and file formats can still experience breaking changes in future
versions of Nix.

You enable Nix flakes by adding the follwing to your Nix configuration
file on `~/.config/nix/nix.conf`.

```
experimental-features = nix-command flakes
```

### Create Your Home Manager Flake Definition

With a working Nix installation with Flake support we can now create
our `flake.nix` that defines what should be installed. This can be
created in any user-owned directory. I used the recommended default
path of `~/.config/home-manager`

I looked at the official `flake.nix` template for a stand-alone Nix
installation. A direct link to the commit I looked at is [here].

You can fetch it directly into your current directory with the
following command.

```
nix flake new . -t github:nix-community/home-manager
```

After modifying it slightly with my own description and username it
looked like this.

```nix
{
  description = "Home Manager configuration of Anton Friberg";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations.antonfr = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [./home.nix];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };
  };
}
```

This references the home configuration module in a separate nix module on
`home.nix` on the same path. This we will need to create next.

### Define Your Initial Home Configuration

In the `home.nix` file we can start writing our declarative specification
on our user environment that we want managed under Nix. I started out with
the minimal setup seen below.

```nix
{
  config,
  pkgs,
  ...
}: {
  home = {
    username = "antonfr";
    homeDirectory = "/home/antonfr";
    stateVersion = "22.11";

    packages = with pkgs; [
      gh
      git
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  programs.home-manager.enable = true;
}
```

Here I have only added GitHub CLI and git packages to the installation.

### Install your Home Manager Flake package

The easiest way to install Home Manager is actually by using Home Manager.
That might seem confusing but with Nix we can actually use Home Manager
directly without having it installed anywhere. 

```
# Activate a nix shell with latest home-manager from github
$ nix shell github:nix-community/home-manager
# Check that home-manager exists in the activated shell
$ home-manager --version
23.11-pre
# Install your home-manager flake using home-manager
$ home-manager switch --flake ~/.config/home-manager
Starting Home Manager activation
...
# home-manager is now installed even outside the nix shell
$ exit
$ home-manager --version
23.11-pre
# We also have our other packages available
$ git --version
git version 2.40.1
```

## Nix Garbage Collect

Nix keeps track of every package that you have ever used and every iteration
of installed home-manager configurations in something called generations.
This allows one to get back to a working setup after every change. However,
it quickly fills up the drive with package versions.

To clean up old generations and unused packages you can run the following.

```
nix-collect-garbage -d
```

## Update Home Manager Packages

You might want to update your packages that are managed by Home Manager even
without changing the `home.nix` directly. This is done by updating the list
of available packages and updating the flake.nix of your home-manager package.

This can be done by a single command.

```
nix flake update ~/.config/home-manager
```

Then you also need to apply the update.

```
home-manager switch --flake ~/.config/home-manager
```

[Nix package manager]: https://nixos.org/
[Home Manager]: https://nix-community.github.io/home-manager/
[Nixpkgs]: https://search.nixos.org/packages
[Nix Flakes]: https://nixos.wiki/wiki/Flakes
[Nix Channels]: https://nixos.wiki/wiki/Nix_channels
[here]: https://github.com/nix-community/home-manager/blob/6bdd72b914fc3472be807bc9b427650b49808a94/templates/standalone/flake.nix
