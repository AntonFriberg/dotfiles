{
  config,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    systemd.enable = false;
    settings = {
      theme = "Nord";
      font-family = "Hack Nerd Font Mono";
      font-size = 12;
      command = "${config.home.homeDirectory}/.nix-profile/bin/fish";
      cursor-style = "block";
      cursor-style-blink = false;
      shell-integration-features = "no-cursor";
      window-decoration = false;
      background-opacity = 1;
    };
  };
}
