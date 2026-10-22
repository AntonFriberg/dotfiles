{
  config,
  pkgs,
  ...
}: {
  programs.chromium = {
    enable = true;
    # Widevine CDM for DRM playback (Netflix, Spotify, ...)
    package = pkgs.chromium.override {enableWideVine = true;};
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
