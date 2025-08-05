{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    firefox-addons,
    home-manager,
    nix-index-database,
    nixGL,
    nixpkgs-stable,
    nixpkgs,
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
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config = pkgsConfig;
    };
  in {
    homeConfigurations."antonfr" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit pkgs-stable;
        inherit nixGL;
        inherit firefox-addons;
      };
      # Useful stuff for managing modules between hosts
      # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/modularize-the-configuration
      modules = [
        nix-index-database.homeModules.nix-index
        ./modules/home.nix
        ./modules/terminal
        ./modules/gui
        ./modules/work
        ./overlays
      ];
    };
  };
}
