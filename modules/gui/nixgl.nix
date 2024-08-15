{
  nixGL,
  pkgs,
  ...
}: let
  nixGLIntel = nixGL.packages.${pkgs.system}.nixGLIntel;
in {
  imports = [
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
      sha256 = "f14874544414b9f6b068cfb8c19d2054825b8531f827ec292c2b0ecc5376b305";
    })
  ];

  nixGL.prefix = "${nixGLIntel}/bin/nixGLIntel";
}
