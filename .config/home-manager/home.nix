{
  config,
  pkgs,
  ...
}: {
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

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

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
