{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let specialArgs = { inherit inputs; };

    in {
      nixosConfigurations.foobar = let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          config.allowUnfree = true;
          inherit system;
        };
      in nixpkgs.lib.nixosSystem {
        inherit pkgs system specialArgs;
        modules = [
          ./hosts/foobar/configuration.nix
          home-manager.nixosModules.home-manager
          {
            # home-manager = {
            #   users."leitz" = import ./hosts/foobar/home.nix;
            #   useGlobalPkgs = true;
            #   useUserPackages = false;
            #   extraSpecialArgs = specialArgs;
            # };
          }
        ];
      };
    };
}

