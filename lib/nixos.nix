{ lib, ... }:

{
  readDirNames = path:
    builtins.attrNames
    (lib.filterAttrs (_: type: type == "directory") (builtins.readDir path));

  mkNixosSystem = { hostname, inputs }:
    let
      inherit (inputs) home-manager nixpkgs;
      dir = ../hosts + "/${hostname}";
      custom-raw = import (dir + /custom.nix);
      system = custom-raw.system;

      overlays = [
        (final: prev: {
          # Shorter than prev.lib.extend (f: p: ...), but I don't know
          # if there's another difference.
          lib = prev.lib // { my = import ./. { inherit (final) lib; }; };
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
      specialArgs = { inherit inputs system custom; };
      users = lib.mapAttrs (userName: userDef:
        import (../users + "/${userDef.userDefDir}/home.nix")) custom.users;
    in nixpkgs.lib.nixosSystem {
      inherit system pkgs specialArgs;
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
      ];
    };
}
