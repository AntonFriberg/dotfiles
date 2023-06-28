{
  config,
  pkgs,
  ...
}: {
  home = {
    username = "antonfr";
    homeDirectory = "/home/antonfr";
    stateVersion = "22.11";

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

  # Add Visual Studio Code
  programs.vscode = {
    enable = true;
  };
}
