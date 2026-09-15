# CLAUDE.md

This file provides guidance to AI coding assistants working in this repository.

## Overview

Personal home-manager configuration (dotfiles) for managing packages, scripts, and system configuration on Ubuntu, Debian, and Arch Linux using Nix flakes. Targets non-NixOS systems via `targets.genericLinux`.

## Validation and Application

```fish
# Format changed Nix files
alejandra <changed-file.nix>

# Fast, non-mutating evaluation after Nix changes
nix eval .#homeConfigurations.antonfr.activationPackage.drvPath

# Full non-mutating build before applying configuration
nix shell nixpkgs#home-manager -c home-manager build --flake .#antonfr

# Apply only after a successful build and explicit approval
home-manager switch --flake .#antonfr  # or alias: hms

# Validate all flake outputs, especially after flake.nix or flake.lock changes
nix flake check
```

Run the smallest applicable validation first, then escalate to a full build
when module wiring, packages, or activation behavior changes.

## Architecture

**Flake structure** (`flake.nix`): Single `homeConfigurations."antonfr"` output for x86_64-linux. Inputs include nixpkgs (unstable), home-manager, niri, nix-index-database, firefox-addons, dank-material-shell, and spicetify-nix.

**Module organization** (`modules/`):
- `home.nix` — User identity, session variables (EDITOR, BROWSER, XDG), systemd service linking
- `terminal/` — Shell (fish), git, SSH, Kubernetes tools, CLI packages
- `gui/` — Window manager (niri), terminals, browsers, VS Code, media
- `secrets/` — Secret management via sops-nix and age, decrypting to RAM outside `/nix/store`
- `work/` — Work-specific packages and conditional git config (overrides git email based on SSH URL patterns, uses system git/ssh for GSSAPI)

**Overlays** (`overlays/default.nix`): Infrastructure exists but currently minimal.

## Conventions

- **Nord color scheme** is used consistently across all applications (hex values like `#2E3440` for background). Maintain this when adding or modifying UI configurations.
- **Nix formatter**: `alejandra` (not `nixfmt` or `nixpkgs-fmt`).
- **Package lists** use `lib.mkMerge` with `with pkgs; [ ... ]` blocks. Do not use `lib.mkMerge` for unrelated options.
- **Module ownership**: add application configuration to its category module; add imports and category-wide packages to that category's `default.nix`.
- `allowUnfree = true` is set globally.
- Home Manager state version: `26.05`.

## Change-Specific Validation

- **Nix modules**: format changed files and evaluate the activation package. Run a
  full Home Manager build for module imports, packages, service changes, or
  activation behavior.
- **Flake inputs**: run `nix flake check` after changing `flake.nix` or
  `flake.lock`.
- **SOPS secrets**: verify encrypted files with
  `sops decrypt <file> >/dev/null`. For binary JSON files, validate the
  decrypted output with:
  ```fish
  sops decrypt --input-type binary --output-type binary <file> | jq -e .
  ```
- **GitHub Actions**: keep workflow path filters aligned with every file type
  that affects the build. GitHub Actions validates workflow YAML on push and
  pull request.

## Secret Handling

- Encrypted SOPS files may be included in `/nix/store`; decrypted content must
  never be evaluated by Nix or written there.
- Deploy whole-file secrets with `sops.secrets`, `format = "binary"`, an
  explicit target `path`, and a restrictive `mode`. Do not use `home.file`,
  `builtins.readFile`, generated text, or Nix interpolation for decrypted
  secret content.
- Edit binary secrets with `sopsedit <encrypted-file>`. It places SOPS's
  temporary plaintext under `$XDG_RUNTIME_DIR`; disable editor swap and backup
  files when editing secrets.
- New encrypted files referenced by this flake must be Git-tracked (staged is
  sufficient locally). Untracked files are omitted from the flake source
  snapshot.

## Agent Safety

- Preserve unrelated changes in a dirty worktree; never revert or stage them.
- Do not update `flake.lock` unless the task explicitly requires dependency
  changes.
- Do not run `home-manager switch` without explicit approval after a successful
  build.
- Ask before destructive commands or changes to authentication, SSH, secret
  destinations, or systemd service behavior.
