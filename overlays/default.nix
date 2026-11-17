{...}: {
  nixpkgs.overlays = [
    # (import ./work/openssh.nix)
    (final: prev: let
      copilotAppWebkitShim = final.runCommandCC "copilot-app-webkit-shim" {} ''
        mkdir -p $out/lib
        $CC -shared -fPIC -O2 -Wall -Werror \
          -o $out/lib/libcopilot-app-webkit-shim.so \
          ${./copilot-app-webkit-shim.c} -ldl
      '';
    in {
      github-copilot-app = prev.github-copilot-app.overrideAttrs (old: {
        # patchelf 0.15 corrupts the ~560 MB main executable's relocations
        # (ld.so: elf_machine_rela_relative assertion); newer patchelf works.
        nativeBuildInputs = [final.patchelfUnstable] ++ (old.nativeBuildInputs or []);
        # Nix alsa-lib honors the host's `pcm.!default { type pipewire }` but
        # cannot find the host plugin, so cpal opens the raw hw device and
        # blocks PipeWire ("Device or resource busy"). Use Nix's plugin.
        # The preloaded shim disables WebKitGTK smooth scrolling (no env/GTK
        # toggle exists) and stops the app from forcing shared-memory frame
        # copies (WEBKIT_DMABUF_RENDERER_FORCE_SHM), keeping DMA-BUF zero-copy.
        # Launch with WEBKIT_DMABUF_RENDERER_FORCE_SHM=1 to restore SHM.
        preFixup =
          (old.preFixup or "")
          + ''
            gappsWrapperArgs+=(--set-default ALSA_PLUGIN_DIR "${final.pipewire}/lib/alsa-lib")
            gappsWrapperArgs+=(--prefix LD_PRELOAD : "${copilotAppWebkitShim}/lib/libcopilot-app-webkit-shim.so")
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
