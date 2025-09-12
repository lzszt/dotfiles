{ lib, ... }:

{
  readDirNames =
    path:
    path |> builtins.readDir |> lib.filterAttrs (_: type: type == "directory") |> builtins.attrNames;

  mkNixosSystem =
    {
      hostname,
      inputs,
      self,
      ...
    }:
    let
      inherit (inputs) home-manager nixpkgs;
      dir = ../hosts + "/${hostname}";
      custom-raw = import (dir + /custom.nix);
      system = custom-raw.system;

      overlays = [
        inputs.nur.overlays.default
        (final: prev: {
          # Shorter than prev.lib.extend (f: p: ...), but I don't know
          # if there's another difference.
          lib = prev.lib // {
            my = import ./. { inherit (final) lib; };
          };
        })
      ];

      pkgs = import nixpkgs {
        config.allowUnfree = true;
        inherit system overlays;
      };

      custom = custom-raw // {
        inherit hostname;
        secrets = inputs.dotfile-secrets.packages.${system};
      };
      specialArgs = {
        inputs = builtins.removeAttrs inputs [ "nur" ];
        inherit system custom self;
      };
      users = lib.mapAttrs (
        userName: userDef: import (../users + "/${userDef.userDefDir}/home.nix")
      ) custom.users;
    in
    nixpkgs.lib.nixosSystem {
      inherit
        system
        pkgs
        specialArgs
        ;
      modules = [
        (dir + /configuration.nix)
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = false;
            extraSpecialArgs = specialArgs;
            inherit users;
          };
        }
        inputs.agenix.nixosModules.default
      ];
    };
}
