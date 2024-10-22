{
  nixGL,
  pkgs,
  ...
}: {
  imports = [
    # TODO: remove when https://github.com/nix-community/home-manager/pull/5355 gets merged:
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
      sha256 = "1krclaga358k3swz2n5wbni1b2r7mcxdzr6d7im6b66w3sbpvnb3";
    })
  ];

  nixGL = {
    packages = nixGL.packages; # you must set this or everything will be a noop
    defaultWrapper = "mesa"; # choose from options
  };
}
