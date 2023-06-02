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
          ./hosts/nixos-desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.leitz = import ./hosts/nixos-desktop/users/leitz/home.nix;
              users.ag = import ./hosts/nixos-desktop/users/ag/home.nix;
              extraSpecialArgs = specialArgs;
            };
          }
        ];
      };
      devShells.${system}.default = let pkgs = nixpkgs.legacyPackages.${system};
      in pkgs.mkShell {
        buildInputs = [
          (pkgs.haskellPackages.ghcWithPackages (hp:
            with hp; [
              ormolu
              haskell-language-server
              dbus
              xmonad-contrib
              monad-logger
            ]))
        ];
      };
    };
}
