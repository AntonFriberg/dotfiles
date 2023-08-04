{
  config,
  pkgs,
  username,
  homeDirectory,
  ...
}: {
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };
  home = {
    inherit username homeDirectory;

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.11";

    # Add packages
    packages = with pkgs; [
      alejandra
      delta
      docker-compose
      fuzzel
      fzf
      gh
      git
      git-crypt
      glances
      go-migrate
      helmfile
      httpie
      ipcalc
      jq
      k9s
      kubectl
      kubectl-node-shell
      kubeconform
      kubeseal
      kubectx
      kubernetes-helm
      ncdu
      openssh
      radeontop
      rclone
      ripgrep
      rtx
      tealdeer
      vagrant
      yadm
      yt-dlp
      (nerdfonts.override {
        fonts = [
          "Hack"
          "FiraCode"
          "FiraMono"
          "CascadiaCode"
          "Cousine"
          "DroidSansMono"
          "JetBrainsMono"
          "SourceCodePro"
        ];
      })
    ];
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Environment variables to set at login
  home.sessionVariables = {
    # Set XDG directories
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_BIN_HOME = "$HOME/.local/bin";
    XDG_LIB_HOME = "$HOME/.local/lib";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
    # Tell applications to use wayland
    XDG_SESSION_TYPE = "wayland";
    # GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    # Fix cursor on non wayland native applications
    XCURSOR_SIZE = "24";
    # VS Code under wayland
    NIXOS_OZONE_WL = "1";
    # Set default applications
    VISUAL = "vim";
    EDITOR = "vim";
    TERMINAL = "foot";
    BROWSER = "firefox";
    PAGER = "less";
    DESKTOP = "sway";
    # Respect XDG directories
    DOCKER_CONFIG = "$HOME/.config/docker";
    LESSHISTFILE = "-"; # Disable less history
    # Other configs
    PYTHONDONTWRITEBYTECODE = "true";
    PIP_REQUIRE_VIRTUALENV = "true";
    # SSH Agent
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";
  };

  # SSH configs
  programs.ssh = {
    enable = true;
    includes = [
      "config.d/*"
    ];
    extraConfig = ''
      AddKeysToAgent yes
      SetEnv TERM=xterm-256color
      ForwardX11 no
      Compression yes
      ControlMaster auto
      ControlPath ~/.ssh/masters/%r@%h-%p
      ControlPersist 600
      ServerAliveInterval 25
      ServerAliveCountMax 3
      GSSAPIAuthentication no
    '';
  };

  # Change shell to fish
  programs.fish = {
    enable = true;
    plugins = [
      {
        # After first install you need to call the setup script manually
        # fish_path=(status fish-path) exec $fish_path -C "emit _tide_init_install"
        name = "tide";
        src = pkgs.fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "6833806ba2eaa1a2d72a5015f59c284f06c1d2db";
          sha256 = "1qqkxpi4pl0s507gj4xv7b58ykbqzxbhxmw949ja3srph9i2qbmy";
        };
      }
      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "b3dd471bcc885b597c3922e4de836e06415e52dd";
          sha256 = "13wdsvpazivlxk921ccqbk7gl6ya2md8f45rckbn8rn119ckf7fy";
        };
      }
      {
        name = "bang-bang";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-bang-bang";
          rev = "816c66df34e1cb94a476fa6418d46206ef84e8d3";
          sha256 = "0dx4z0mmrwfkg8qh1yis75vwf69ng51m3icsiiw7k2cwc02mg76z";
        };
      }
    ];
    functions = {
      # Custom function for sourcing .env files
      envsource = ''
        for line in (cat $argv | grep -v '^#' | grep -v '^\s*$')
          set item (string split -m 1 '=' $line)
          set -gx $item[1] (string trim --chars=\'\" $item[2])
          echo "Exported key $item[1]"
        end
      '';
    };
    shellAliases = {
      code = "~/.nix-profile/bin/code --enable-features=WaylandWindowDecorations --ozone-platform=wayland";
      update = "sudo apt update";
      upgrade = "sudo apt upgrade";
      hmu = "nix flake update ~/.config/home-manager";
      hms = "home-manager switch --flake ~/.config/home-manager";
      hmgc = "nix-collect-garbage --delete-older-than 30d";
    };
    shellInit = ''
      # Disable help message
      set -U fish_greeting
      # Nix
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end
      # home-manager
      fenv 'export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels''${NIX_PATH:+:$NIX_PATH}'
      # Rtx to manage Python installations
      rtx activate --quiet --shell fish | source
      # Fix for python dependencies under nix
      #fenv 'export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/:/run/opengl-driver/lib/:$LD_LIBRARY_PATH'
      # Use ssh-agent
      if test -z (pgrep ssh-agent | string collect)
        eval (ssh-agent -c)
        set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
        set -Ux SSH_AGENT_PID $SSH_AGENT_PID
      end
      # Add to PATH
      fish_add_path -m ~/.local/bin
    '';
  };

  # SSH Agent systemd user service
  systemd.user.services = {
    ssh-agent = {
      Unit = {
        Description = "SSH key agent";
        Documentation = [
          "https://wiki.archlinux.org/index.php/SSH_keys#Start_ssh-agent_with_systemd_user"
        ];
      };
      Service = {
        Type = "simple";
        Environment = ["SSH_AUTH_SOCK=%t/ssh-agent.socket" "DISPLAY=:0"];
        ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
      };
      Install = {WantedBy = ["default.target"];};
    };
  };

  # You might need to install terminfo globally manually
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "Cousine Nerd Font Mono:size=9";
        dpi-aware = "yes";
        pad = "10x10";
      };
      cursor = {color = "2e3440 d8dee9";};
      colors = {
        foreground = "d8dee9";
        background = "2e3440";
        alpha = "0.9";
        selection-foreground = "d8dee9";
        selection-background = "4c566a";
        regular0 = "3b4252";
        regular1 = "bf616a";
        regular2 = "a3be8c";
        regular3 = "ebcb8b";
        regular4 = "81a1c1";
        regular5 = "b48ead";
        regular6 = "88c0d0";
        regular7 = "e5e9f0";
        bright0 = "4c566a";
        bright1 = "bf616a";
        bright2 = "a3be8c";
        bright3 = "ebcb8b";
        bright4 = "81a1c1";
        bright5 = "b48ead";
        bright6 = "8fbcbb";
        bright7 = "eceff4";
        dim0 = "373e4d";
        dim1 = "94545d";
        dim2 = "809575";
        dim3 = "b29e75";
        dim4 = "68809a";
        dim5 = "8c738c";
        dim6 = "6d96a5";
        dim7 = "aeb3bb";
      };
    };
  };

  # Add Visual Studio Code
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      arcticicestudio.nord-visual-studio-code
      bbenoist.nix
      bmalehorn.vscode-fish
      esbenp.prettier-vscode
      kamadorueda.alejandra
      ms-python.python
      ms-python.vscode-pylance
      ms-vscode-remote.remote-ssh
      redhat.vscode-yaml
      tamasfe.even-better-toml
    ];
    userSettings = {
      "[json]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
      "[python]" = {"editor.defaultFormatter" = "ms-python.black-formatter";};
      "[yaml]" = {"editor.defaultFormatter" = "redhat.vscode-yaml";};
      "editor.copyWithSyntaxHighlighting" = false;
      "editor.fontFamily" = "'Cousine', 'Hack', 'monospace', monospace, 'Droid Sans Fallback'";
      "editor.minimap.enabled" = false;
      "editor.renderWhitespace" = "boundary";
      "editor.rulers" = [80 120];
      "files.insertFinalNewline" = true;
      "files.trimTrailingWhitespace" = true;
      "python.analysis.typeCheckingMode" = "basic";
      "python.languageServer" = "Pylance";
      "terminal.integrated.fontFamily" = "Cousine Nerd Font Mono";
      "window.titleBarStyle" = "custom";
      "window.zoomLevel" = 1;
      "workbench.colorTheme" = "Nord";
      "workbench.sideBar.location" = "right";
    };
  };

  # Enable dircolors
  programs.dircolors.enable = true;

  # Install waybar using home-manager to get a more up-to-date version
  programs.waybar.enable = true;

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [batdiff batman batgrep batwatch];
    config = {
      theme = "Nord";
      italic-text = "never";
      # Show line numbers, Git modifications and file header (but no grid)
      style = "numbers,changes,header,grid";
      # Add mouse scrolling support in less (does not work with older
      # versions of "less").
      pager = "less -FR";
      # Use "gitignore" highlighting for ".ignore" files
      map-syntax = [".ignore:.gitignore" "*.jenkinsfile:Groovy"];
    };
  };

  # Allow fontconfig to discover fonts and configurations installed through home.packages
  fonts.fontconfig.enable = true;

  # Ease usage on non-NixOS installations
  targets.genericLinux.enable = true;

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
