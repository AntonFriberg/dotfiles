{
  config,
  pkgs,
  ...
}: {
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--ozone-platform-hint=auto"
    ];
  };
}
