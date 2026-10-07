{...}: {
  nixpkgs.overlays = [
    # (import ./work/openssh.nix)
    # Remove this pin once the locked Nixpkgs provides Copilot app >= 1.1.27.
    (final: prev: {
      github-copilot-app = prev.github-copilot-app.overrideAttrs (_: rec {
        version = "1.1.27";

        src = final.fetchurl {
          url = "https://github.com/github/app/releases/download/v${version}/GitHub-Copilot-linux-x64.deb";
          hash = "sha256-E6siamKcrEnq8oFC4Hkydi4EBigSfJxm61vvZIYtWEY=";
        };
      });
    })
  ];
}
