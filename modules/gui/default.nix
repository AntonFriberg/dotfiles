{...}: {
  imports = [
    # Fix for GPU stuff on non-nixos systems
    ./nixGL.nix
  ];
}
