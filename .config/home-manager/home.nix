{
  config,
  pkgs,
  ...
}: {
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };
  home = {
    username = "antonfr";
    homeDirectory = "/home/antonfr";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "22.11";

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
      tealdeer
      vagrant
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
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";
  };

  # SSH configs
  programs.ssh = {
    enable = true;
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

  # Add Visual Studio Code
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      arcticicestudio.nord-visual-studio-code
      bbenoist.nix
      bmalehorn.vscode-fish
      bungcip.better-toml
      esbenp.prettier-vscode
      kamadorueda.alejandra
      ms-python.python
      ms-python.vscode-pylance
      redhat.vscode-yaml
    ];
    userSettings = {
      "[json]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
      "[python]" = {};
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
}
