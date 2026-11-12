{...}: {
  nixpkgs.overlays = [
    # (import ./work/openssh.nix)
    (final: prev: {
      github-copilot-app = prev.github-copilot-app.overrideAttrs (old: {
        # patchelf 0.15 corrupts the ~560 MB main executable's relocations
        # (ld.so: elf_machine_rela_relative assertion); newer patchelf works.
        nativeBuildInputs = [final.patchelfUnstable] ++ (old.nativeBuildInputs or []);
        # Nix alsa-lib honors the host's `pcm.!default { type pipewire }` but
        # cannot find the host plugin, so cpal opens the raw hw device and
        # blocks PipeWire ("Device or resource busy"). Use Nix's plugin.
        preFixup =
          (old.preFixup or "")
          + ''
            gappsWrapperArgs+=(--set-default ALSA_PLUGIN_DIR "${final.pipewire}/lib/alsa-lib")
          '';
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
