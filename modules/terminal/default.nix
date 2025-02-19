{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./fish.nix
    ./git.nix
    ./kubernetes.nix
    ./mise.nix
    ./ssh.nix
  ];

  # Add packages
  home.packages = lib.mkMerge [
    (with pkgs; [
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
      jira-cli-go
      jq
      mmv
      ncdu
      nerd-fonts.caskaydia-mono
      nerd-fonts.cousine
      nerd-fonts.droid-sans-mono
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.hack
      nerd-fonts.jetbrains-mono
      nerd-fonts.sauce-code-pro
      ouch
      radeontop
      rclone
      ripgrep
      tealdeer
      uv
      yt-dlp
      yq-go
    ])
  ];

  # Allow fontconfig to discover fonts and configurations installed through home.packages
  fonts.fontconfig.enable = true;

  programs.nix-index.enable = true;

  programs.micro = {
    enable = true;
    settings = {
      colorscheme = "nord-16"; # installed via below
    };
  };

  xdg.configFile."micro/colorschemes/nord-16.micro".source = "${pkgs.fetchFromGitHub {
    owner = "KiranWells";
    repo = "micro-nord-tc-colors";
    rev = "132e847cb02ee20bfae566212d0358f0f98313cb";
    sha256 = "m1qOvnfOCE8itE/LkDWeZ7yyIUXcAlAvw8FPWZeGfvw="; # nix flake prefetch github:KiranWells/micro-nord-tc-colors/132e847cb02ee20bfae566212d0358f0f98313cb
  }}/colorschemes/nord-16.micro";

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      #batdiff
      batman
      batgrep
      batwatch
    ];
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
