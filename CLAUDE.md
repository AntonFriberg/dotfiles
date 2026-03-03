# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal home-manager configuration (dotfiles) for managing packages, scripts, and system configuration on Ubuntu, Debian, and Arch Linux using Nix flakes. Targets non-NixOS systems via `targets.genericLinux`.

## Key Commands

```fish
# Apply configuration changes
home-manager switch --flake ~/.config/home-manager  # or alias: hms

# Update flake dependencies
nix flake update --flake ~/.config/home-manager     # or alias: hmu

# Garbage collect old generations
nix-collect-garbage --delete-older-than 30d         # or alias: hmgc

# Format Nix files
alejandra <file.nix>
```

## Architecture

**Flake structure** (`flake.nix`): Single `homeConfigurations."antonfr"` output for x86_64-linux. Inputs include nixpkgs (unstable), home-manager, niri, nix-index-database, firefox-addons, dank-material-shell, and spicetify-nix.

**Module organization** (`modules/`):
- `home.nix` — User identity, session variables (EDITOR, BROWSER, XDG), systemd service linking
- `terminal/` — Shell (fish), git, SSH, kubernetes tools, CLI packages
- `gui/` — Window manager (niri), terminals (alacritty, foot, ghostty), browsers (firefox, chrome), VS Code, media
- `work/` — Work-specific packages and conditional git config (overrides git email based on SSH URL patterns, uses system git/ssh for GSSAPI)

**Overlays** (`overlays/default.nix`): Infrastructure exists but currently minimal.

## Conventions

- **Nord color scheme** is used consistently across all applications (hex values like `#2E3440` for background). Maintain this when adding or modifying UI configurations.
- **Nix formatter**: `alejandra` (not `nixfmt` or `nixpkgs-fmt`).
- **Package lists** use `lib.mkMerge` with `with pkgs; [ ... ]` blocks.
- Each module category has a `default.nix` that imports sub-modules and defines category-specific packages.
- `allowUnfree = true` is set globally.
- Home Manager state version: `25.11`.
