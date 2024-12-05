{...}: {
  home = let
    user = "antonfr";
  in {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "23.11";
    sessionVariables = {
      # Set default applications
      SHELL = "$HOME/.nix-profile/bin/fish";
      TERMINAL = "alacritty";
      VISUAL = "vim";
      EDITOR = "vim";
      BROWSER = "firefox";
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
    ];
  };

  programs.home-manager.enable = true;

  # Ease usage on non-NixOS installations
  targets.genericLinux.enable = true;

  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$HOME/.nix-profile/bin:$PATH"
  '';

  # Better font rendering
  xdg.configFile."fontconfig/conf.d/1-better-rendering.conf".text = ''
    <!-- Better font rendering by changing settings. -->
    <!-- https://wiki.archlinux.org/title/font_configuration -->
    <match target="font">
      <!-- disable embedded bitmaps in fonts to fix Calibri, Cambria, etc. -->
      <edit name="embeddedbitmap" mode="assign">
        <bool>false</bool>
      </edit>
      <!-- Enable anti-aliasing in font rendering -->
      <edit mode="assign" name="antialias">
        <bool>true</bool>
      </edit>
      <!-- Enable hinting in font rendering -->
      <edit mode="assign" name="hinting">
        <bool>true</bool>
      </edit>
      <!-- Only hint slightly -->
      <edit mode="assign" name="hintstyle">
        <const>hintslight</const>
      </edit>
      <!-- Set subpixel rendering to reduce color fringing -->
      <edit mode="assign" name="lcdfilter">
        <const>lcddefault</const>
      </edit>
      <!-- Set correct pixel alignment-->
      <edit mode="assign" name="rgba">
        <const>rgb</const>
      </edit>
    </match>
  '';
}
