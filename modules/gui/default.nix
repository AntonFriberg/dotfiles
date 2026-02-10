{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./chrome.nix
    ./firefox.nix
    ./foot.nix
    ./vscode.nix
    # ./hyprland.nix
    ./mpv.nix
    ./ghostty.nix
    ./niri.nix
  ];

  # Add packages
  home.packages = lib.mkMerge [
    (with pkgs; [
      # antigravity # Currently not working, I am not using it that much
      grim
      slurp
      spotify
      swaybg
      wdisplays
    ])
  ];
}
