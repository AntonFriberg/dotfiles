{...}: {
  imports = [
    ./alacritty.nix
    ./vscode.nix
    # Fix for GPU stuff on non-nixos systems
    ./nixgl.nix
  ];
}
