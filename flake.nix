{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    firefox-addons,
    home-manager,
    niri,
    nix-index-database,
    nixpkgs,
    dms,
    spicetify,
    ...
  }: let
    system = "x86_64-linux";
    pkgsConfig = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
    pkgs = import nixpkgs {
      inherit system;
      config = pkgsConfig;
    };
  in {
    homeConfigurations."antonfr" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit firefox-addons;
        inherit spicetify;
      };
      # Useful stuff for managing modules between hosts
      # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/modularize-the-configuration
      modules = [
        nix-index-database.homeModules.nix-index
        niri.homeModules.niri
        dms.homeModules.dank-material-shell
        dms.homeModules.niri
        spicetify.homeManagerModules.spicetify
        ./modules/home.nix
        ./modules/terminal
        ./modules/gui
        ./modules/work
        ./overlays
      ];
    };
  };
}
