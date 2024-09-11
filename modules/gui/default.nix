{...}: {
  imports = [
    ./alacritty.nix
    ./chrome.nix
    ./firefox.nix
    ./vscode.nix
    # Fix for GPU stuff on non-nixos systems
    ./nixgl.nix
  ];
}
