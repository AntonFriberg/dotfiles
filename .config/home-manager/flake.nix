{
  description = "Home Manager configuration of Anton Friberg";

  # Flake inputs are Nix dependencies that a flake needs to be built. Each input
  # in the set can be pulled from various sources, such as github, generic git
  # repositories, and even your filesystem.
  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Flake outputs are what a flake produces as part of its build. Each flake can
  # have many different outputs simultaneously, including but not limited to:
  #   Nix packages
  #   Nix development environments
  #   NixOS configurations
  #   Nix templates
  # Flake outputs are defined by a function, which takes an attribute set as
  # input, containing each of the inputs to that flake
  # (named after the chosen identifier in the inputs section).
  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    # Secrets from YADM encrypted file
    secrets = import ./secrets.nix;
    users = secrets.users;
    hosts = secrets.hosts;
  in {
    formatter.${system} = pkgs.alejandra;

    homeConfigurations = {
      # Home Manager entries for each user and host combination as `user@host`
      "${users.work}@${hosts.work.laptop}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [./home.nix];
        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          username = users.work;
          homeDirectory = "/home/${users.work}";
        };
      };
      "${users.work}@${hosts.work.stationary}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home.nix];
        extraSpecialArgs = {
          username = users.work;
          homeDirectory = "/home/${users.work}";
        };
      };
    };
  };
}
