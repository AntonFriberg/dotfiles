{
  config,
  pkgs,
  username,
  homeDirectory,
  secrets,
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
      bandwhich
      choose
      comma
      delta
      docker-compose
      dogdns
      fd
      fzf
      git-crypt
      glances
      go-migrate
      helmfile
      httpie
      ipcalc
      jq
      k9s
      kubeconform
      kubectl
      kubectl-node-shell
      kubectx
      kubernetes-helm
      kubeseal
      ncdu
      ouch
      radeontop
      rclone
      ripgrep
      tealdeer
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

  # Integrate shell's command-not-found with nix available packages
  # You need to run nix-index manually to update index database
  programs.nix-index.enable = true;

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
    # NIXOS_OZONE_WL = "1";
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
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
    # # Fix for Red Hat IdM
    LD_PRELOAD = "/lib/x86_64-linux-gnu/libnss_sss.so.2";
  };

  # Git config

  programs.git = {
    enable = true;
    userName = "Anton Friberg";
    userEmail = secrets.emails.personal;
    ignores = [
      ".env"
      ".mise.toml"
      ".venv"
    ];
    aliases = {
      # List available aliases
      aliases = "!git config --get-regexp alias | sed -re 's/alias\\.(\\S*)\\s(.*)$/\\1 = \\2/g'";
      # Command shortcuts
      ci = "commit";
      co = "checkhout";
      st = "status";
      # Display tree-like log, default log is not ideal
      lg = "log --graph --date=relative --pretty=tformat:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%an %ad)%Creset'";
      # Useful when you have to update your last commit
      # with staged files without editing the commit message.
      oops = "commit --amend --no-edit";
      # Ensure that force-pushing won't lose someone else's work (only your own).
      push-with-lease = "push --force-with-lease";
      # List local commits that were not pushed to remote repository
      review-local = "!git lg @{push}..";
      # Edit last commit message
      reword = "commit --amend";
      # Undo last commit but keep changed files in stage
      uncommit = "reset --soft HEAD~1";
      # Remove file(s) from Git but not from disk
      untrack = "rm --cache --";
    };
    extraConfig = {
      color = {
        ui = "auto";
      };
      diff = {
        # Use better, descriptive initials (c, i, w) instead of a/b.
        mnemonicPrefix = true;
        # Show renames/moves as such
        renames = true;
        # When using --word-diff, assume --word-diff-regex=.
        wordRegex = ".";
        # Display submodule-related information (commit listings)
        submodule = "log";
        # Use VSCode as default diff tool when running `git diff-tool`
        tool = "vscode";
      };
      log = {
        # Use abbrev SHAs whenever possible/relevant instead of full 40 chars
        abbrevCommit = true;
        # Automatically --follow when given a single path
        follow = true;
        # Disable decorate for reflog
        # (because there is no dedicated `reflog` section available)
        decorate = false;
      };
      pull = {
        # This is GREAT… when you know what you're doing and are careful
        # not to pull --no-rebase over a local line containing a true merge.
        rebase = true;
        # This option, which does away with the one gotcha of
        # auto-rebasing on pulls, is only available from 1.8.5 onwards.
        # rebase = "preserve";
        # WARNING! This option, which is the latest variation, is only
        # available from 2.18 onwards.
        # rebase = "merges";
      };
      status = {
        short = true;
      };
      format = {
        pretty = "format:%h%Cgreen%d%Creset %C(yellow)%an %C(cyan)%cr%Creset %s";
      };
    };
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  # SSH configs
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    compression = true;
    controlMaster = "auto";
    controlPersist = "10m";
    serverAliveInterval = 25;
    includes = [
      "config.d/*"
    ];
    extraConfig = ''
      SetEnv TERM=xterm-256color
      ForwardX11 no
    '';
  };

  # Change shell to fish
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "foreign-env";
        src = pkgs.fishPlugins.foreign-env.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "puffer";
        src = pkgs.fishPlugins.puffer.src;
      }
      {
        name = "forgit";
        src = pkgs.fishPlugins.forgit.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
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
      update = "sudo apt update";
      upgrade = "sudo apt upgrade";
      hmu = "nix flake update ~/.config/home-manager";
      hms = "home-manager switch --flake ~/.config/home-manager";
      hmgc = "nix-collect-garbage --delete-older-than 30d";
      bandwhich = "sudo $(which bandwhich)";
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
      # Fix for python dependencies under nix
      #fenv 'export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/:/run/opengl-driver/lib/:$LD_LIBRARY_PATH'
      # Add to PATH
      fish_add_path -m ~/.local/bin
    '';
  };

  programs.micro = {
    enable = true;
    settings = {
      colorscheme = "nord-16"; # micro --plugin install nordcolors
    };
  };

  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    globalConfig = {
      tools = {
        python = "3.11";
        poetry = {
          version = "1.7.1";
        };
      };
      plugins = {
        poetry = "https://github.com/mise-plugins/mise-poetry";
      };
    };
    settings = {
      verbose = false;
      experimental = true;
      # https://github.com/jdx/mise/issues/1501
      trusted_config_paths = [
        "~/.config/mise/config.toml"
      ];
    };
  };

  # SSH Agent systemd user service
  services.ssh-agent.enable = true;

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

  programs.fuzzel = {
    enable = true;
    settings = {
      # https://codeberg.org/dnkl/fuzzel/src/branch/master/fuzzel.ini
      colors = {
        background = "4c566aff";
        text = "eceff4ff";
        selection = "8fbcbbff";
        selection-text = "eceff4ff";
      };
    };
  };

  # Add Visual Studio Code
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = true;
    extensions = with pkgs.vscode-extensions; [
      arcticicestudio.nord-visual-studio-code
      bbenoist.nix
      bmalehorn.vscode-fish
      esbenp.prettier-vscode
      kamadorueda.alejandra
      mhutchie.git-graph
      ms-python.python
      ms-python.vscode-pylance
      ms-vscode-remote.remote-ssh
      redhat.vscode-yaml
      tamasfe.even-better-toml
    ];
    userSettings = {
      "[json]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
      "[python]" = {"editor.defaultFormatter" = null;};
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
      "extensions.ignoreRecommendations" = true;
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
