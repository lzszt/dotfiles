{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfile-secrets.url = "git+ssh://git@github.com/lzszt/dotfile-secrets";
    haskellmode.url = "gitlab:Zwiebeljunge/haskellmode";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      # TODO (felix): generalize this
      system = "x86_64-linux";
      specialArgs = { inherit inputs system; };
    in {
      nixosConfigurations.desktop-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.leitz = import ./users/leitz/home.nix;
              users.ag = import ./users/ag/home.nix;
              extraSpecialArgs = specialArgs;
            };
          }
        ];
      };
    };
}
