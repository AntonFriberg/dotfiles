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
    ./hyprland.nix
    ./mpv.nix
    ./ghostty.nix
  ];

  # Add packages
  home.packages = lib.mkMerge [
    (with pkgs; [
      spotify
      zed-editor
      grim
      slurp
      swaybg
      wdisplays
    ])
  ];
}
