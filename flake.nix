{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    firefox-addons,
    home-manager,
    hyprpanel,
    nix-index-database,
    nixGL,
    ghostty,
    nixpkgs,
    ...
  }: {
    homeConfigurations."antonfr" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
      extraSpecialArgs = {
        inherit nixGL;
        inherit firefox-addons;
        inherit ghostty;
        inherit hyprpanel;
      };
      # Useful stuff for managing modules between hosts
      # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/modularize-the-configuration
      modules = [
        nix-index-database.hmModules.nix-index
        ./modules/home.nix
        ./modules/terminal
        ./modules/gui
        ./modules/work
        ./overlays
      ];
    };
  };
}
