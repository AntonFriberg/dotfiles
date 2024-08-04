{...}: {
  imports = [
    ./alacritty.nix
    # Fix for GPU stuff on non-nixos systems
    ./nixGL.nix
  ];
}
