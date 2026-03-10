{
  config,
  pkgs,
  ...
}: {
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--enable-features=OverlayScrollbar"
    ];
    extensions = [
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
      {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";} # ublock
      {id = "fihnjjcciajhdojfnbdddfaoknhalnja";} # I don't care about cookies
    ];
  };
}
