{
  config,
  lib,
  pkgs,
  spicetify,
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
      # spotify
      swaybg
      wdisplays
    ])
  ];

  # Spotify client
  programs.spicetify = let
    spicePkgs = spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    enable = true;
    wayland = false; # Solve ugly blue decorations due to wayland issues
    theme = spicePkgs.themes.text;
    colorScheme = "Nord";
    # enabledExtensions = with spicePkgs.extensions; [
    #   adblock
    #   hidePodcasts
    #   shuffle # shuffle+ (special characters are sanitized out of extension names)
    # ];
    # enabledCustomApps = with spicePkgs.apps; [
    #   newReleases
    #   ncsVisualizer
    # ];
    # enabledSnippets = with spicePkgs.snippets; [
    #   rotatingCoverart
    #   pointer
    # ];
  };
}
