{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-clickhouse.url = "github:NixOS/nixpkgs/5c46f3bd98147c8d82366df95bbef2cab3a967ea"; # https://www.nixhub.io/packages/clickhouse
  };

  outputs = {
    firefox-addons,
    home-manager,
    nix-index-database,
    nixpkgs-clickhouse,
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
    pkgs-clickhouse = import nixpkgs-clickhouse {
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
        inherit pkgs-clickhouse;
        inherit pkgs-stable;
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
