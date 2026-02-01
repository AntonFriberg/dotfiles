{lib, ...}: {
  home = let
    user = "antonfr";
  in {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "25.11";
    sessionVariables = {
      # Set default applications
      SHELL = "$HOME/.nix-profile/bin/fish";
      TERMINAL = "alacritty";
      VISUAL = "vim";
      EDITOR = "micro";
      BROWSER = "firefox-devedition";
      PAGER = "less";
      # Set XDG directories
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
      XDG_LIB_HOME = "$HOME/.local/lib";
      XDG_CACHE_HOME = "$HOME/.cache";
      # Respect XDG directories
      DOCKER_CONFIG = "$HOME/.config/docker";
      LESSHISTFILE = "-"; # Disable less history
      # Python config
      PYTHONDONTWRITEBYTECODE = "true";
      PIP_REQUIRE_VIRTUALENV = "true";
      POETRY_VIRTUALENVS_IN_PROJECT = "true";
      # SSH Agent
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
    };
    sessionPath = [
      "$XDG_CACHE_HOME/.bun/bin"
      "$XDG_BIN_HOME"
    ];
    # Make sure systemd user services are placed in a folder so that non-nixos picks them up.
    activation.linkSystemd = let
      inherit (lib) hm;
    in
      hm.dag.entryBefore ["reloadSystemd"] ''
        # 1. Cleanup old nix-linked services
        # Looks for links in the systemd folder that point to the Nix store and removes them
        find $HOME/.config/systemd/user/ -type l \
          -exec bash -c 'readlink "$0" | grep -q "/nix/store/"' {} \; \
          -delete

        # 2. Link current nix-profile services
        # Finds all unit files in your current profile and links them where systemd can see them
        if [ -d "$HOME/.nix-profile/share/systemd/user/" ]; then
          find "$HOME/.nix-profile/share/systemd/user/" -maxdepth 1 -type f,l \
            -exec ln -sf -t "$HOME/.config/systemd/user/" {} +
        fi
      '';
  };

  programs.home-manager.enable = true;

  # Ease usage on non-NixOS installations
  targets.genericLinux = {
    enable = true;
    gpu.enable = true; # GPU driver integration for non-NixOS systems
  };

  # Automatically (re)start/stop and changed services when activating home-manager configuration
  systemd.user.startServices = true;

  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$HOME/.nix-profile/bin:$PATH"
  '';
}
