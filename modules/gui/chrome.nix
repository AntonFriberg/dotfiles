{
  config,
  pkgs,
  ...
}: {
  programs.chromium = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.chromium;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--enable-features=WaylandWindowDecorations"
      "--ozone-platform-hint=auto"
    ];
  };
}
