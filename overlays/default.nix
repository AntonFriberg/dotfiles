{...}: {
  nixpkgs.overlays = [
    # (import ./work/openssh.nix)
    (final: prev: {
      github-copilot-app = prev.github-copilot-app.overrideAttrs (old: {
        # patchelf 0.15 corrupts the ~560 MB main executable's relocations
        # (ld.so: elf_machine_rela_relative assertion); newer patchelf works.
        nativeBuildInputs = [final.patchelfUnstable] ++ (old.nativeBuildInputs or []);
        # Microsoft.AI.Foundry.Local.Core.so (.NET NativeAOT) dlopens libssl by
        # name; add it to that library's RPATH to avoid "No usable version of
        # libssl was found" aborts at startup.
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
