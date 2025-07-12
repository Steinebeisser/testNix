{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in 
  {
    nixosConfigurations.home-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./devices/home-pc/configuration.nix

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.stein = ./home/home-pc.nix;
        }
      ];
    };
  };
}
