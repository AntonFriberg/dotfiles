{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./fish.nix
    ./git.nix
    ./ssh.nix
  ];

  # Add packages
  home.packages = lib.mkMerge [
    (with pkgs; [
      alejandra
      # bandwhich
      choose
      comma
      # delta
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
      jira-cli-go
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
    ])
  ];

  # Allow fontconfig to discover fonts and configurations installed through home.packages
  fonts.fontconfig.enable = true;

  programs.micro = {
    enable = true;
    settings = {
      colorscheme = "nord-16"; # micro --plugin install nordcolors
    };
  };

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
}
