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
      sha256 = "e9f7da06111c7e669dbeef47f1878ed245392d4e7250237eaf791b734899be3c";
    })
  ];

  nixGL.prefix = "${nixGLIntel}/bin/nixGLIntel";
}
