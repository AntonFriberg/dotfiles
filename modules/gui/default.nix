{...}: {
  imports = [
    ./alacritty.nix
    ./vscode.nix
    ./zettlr.nix
    # Fix for GPU stuff on non-nixos systems
    ./nixgl.nix
  ];
}
