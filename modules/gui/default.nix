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
    ./vscode.nix
    # Fix for GPU stuff on non-nixos systems
    ./nixgl.nix
    ./hyprland.nix
    ./mpv.nix
    ./ghostty.nix
  ];

  # Add packages
  home.packages = lib.mkMerge [
    (with pkgs; [
      (config.lib.nixGL.wrap spotify)
      (config.lib.nixGL.wrap zed-editor)
      grim
      slurp
    ])
  ];
}
