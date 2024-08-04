{...}: {
  home = {
    username = "antonfr";
    homeDirectory = "/home/antonfr";
    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;

  # Ease usage on non-NixOS installations
  targets.genericLinux.enable = true;

  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$HOME/.nix-profile/bin:$PATH"
  '';
}
