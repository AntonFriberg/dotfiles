{
  lib,
  pkgs,
  ...
}: {
  # Add packages
  home.packages = lib.mkMerge [
    (with pkgs; [
      clickhouse
      aws-signing-helper
    ])
  ];

  # Take system packages for git and ssh since I could not get Nix to support GSSAPIKeyExchange that is enabled at work.
  # https://github.com/nix-community/home-manager/issues/4763#issuecomment-1986996921
  programs.git.package = lib.mkForce pkgs.emptyDirectory;
  programs.ssh.package = lib.mkForce pkgs.emptyDirectory;
}
