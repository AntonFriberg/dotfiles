{...}: {
  nixpkgs.overlays = [
    (import ./work/openssh.nix)
  ];
}
