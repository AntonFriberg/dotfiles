{
  config,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "nord";
      font-family = "Hack Nerd Font Mono";
      font-size = 12;
      command = "${config.home.homeDirectory}/.nix-profile/bin/fish";
      cursor-style = "block";
      cursor-style-blink = false;
      shell-integration-features = "no-cursor";
      window-decoration = false;
      background-opacity = 0.8;
    };
  };
}
