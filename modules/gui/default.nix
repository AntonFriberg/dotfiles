{
  config,
  ghostty,
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
  ];

  # Add packages
  home.packages = lib.mkMerge [
    (with pkgs; [
      (config.lib.nixGL.wrap ghostty.packages.x86_64-linux.default)
      (config.lib.nixGL.wrap spotify)
      fuzzel
      grim
      slurp
    ])
  ];
}
