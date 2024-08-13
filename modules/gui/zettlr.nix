{
  config,
  pkgs,
  lib,
  ...
}: {
  # Add packages
  home.packages = lib.mkMerge [
    (with pkgs; [
      (config.lib.nixGL.wrap zettlr)
    ])
  ];
}
