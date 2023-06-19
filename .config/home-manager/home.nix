{
  config,
  pkgs,
  ...
}: {
  home = {
    username = "antonfr";
    homeDirectory = "/home/antonfr";
    stateVersion = "22.11";

    packages = with pkgs; [
      gh
      git
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  programs.home-manager.enable = true;
}
