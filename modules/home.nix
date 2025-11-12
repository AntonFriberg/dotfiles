{...}: {
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
      EDITOR = "vim";
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
  };

  programs.home-manager.enable = true;

  # Ease usage on non-NixOS installations
  targets.genericLinux.enable = true;

  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$HOME/.nix-profile/bin:$PATH"
  '';
}
