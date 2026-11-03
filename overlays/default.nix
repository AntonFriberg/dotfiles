{...}: {
  nixpkgs.overlays = [
    # (import ./work/openssh.nix)
    # Microsoft.AI.Foundry.Local.Core.so (.NET NativeAOT) dlopens libssl by
    # name; add it to that library's RPATH to avoid "No usable version of
    # libssl was found" aborts at startup.
    (final: prev: {
      github-copilot-app = prev.github-copilot-app.overrideAttrs (old: {
        postFixup =
          (old.postFixup or "")
          + ''
            patchelf --add-rpath ${final.lib.getLib final.openssl_3_5}/lib \
              "$out/lib/GitHub Copilot/Microsoft.AI.Foundry.Local.Core.so"
          '';
      });
    })
  ];
}
