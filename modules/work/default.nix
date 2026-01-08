{
  lib,
  pkgs,
  pkgs-clickhouse,
  ...
}: let
  fish_start_logic = ''
    if [ -x "$HOME/.nix-profile/bin/fish" ]; then
        export PATH="$HOME/.nix-profile/bin:$PATH" # Add to PATH
        exec fish
    fi
  '';
in {
  # Add packages
  home.packages = lib.mkMerge [
    [pkgs-clickhouse.clickhouse] # Specifically use pkgs-clickhouse for clickhouse
    (with pkgs; [
      aws-signing-helper
    ])
  ];

  # Bash configuration
  # Workaround since chsh -s is not persisted on company laptop
  home.file = {
    ".bashrc".text = fish_start_logic;
    ".zshrc".text = fish_start_logic;
  };

  # Take system packages for git and ssh since I could not get Nix to support GSSAPIKeyExchange that is enabled at work.
  # https://github.com/nix-community/home-manager/issues/4763#issuecomment-1986996921
  programs.git.package = lib.mkForce pkgs.emptyDirectory;
  programs.ssh.package = lib.mkForce pkgs.emptyDirectory;
}
