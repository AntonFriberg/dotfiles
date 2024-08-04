{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
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
      modules = [
        ./modules/home.nix
      ];
    };
  };
}
