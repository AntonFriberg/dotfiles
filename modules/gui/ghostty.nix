{
  config,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.ghostty;
    enableFishIntegration = true;
    settings = {
      theme = "nord";
      font-size = 10;
      command = "${config.home.homeDirectory}/.nix-profile/bin/fish";
    };
  };
}
