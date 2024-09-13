{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./chrome.nix
    ./firefox.nix
    ./vscode.nix
    # Fix for GPU stuff on non-nixos systems
    ./nixgl.nix
  ];

  # Add packages
  home.packages = lib.mkMerge [
    (with pkgs; [
      (config.lib.nixGL.wrap spotify)
    ])
  ];
}
