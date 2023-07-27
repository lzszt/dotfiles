{ lib, ... }:

{
  readDirNames = path:
    builtins.attrNames
    (lib.filterAttrs (_: type: type == "directory") (builtins.readDir path));

  mkNixosSystem = { hostname, system, inputs, pkgs }:
    let
      inherit (inputs) home-manager nixpkgs;
      dir = ../hosts + "/${hostname}";
      custom = (import (dir + /custom.nix)) // { inherit hostname; };
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
          } // {
            users = users;
          };
        }
      ];
    };

  # (a -> AttrSet) -> [a] -> AttrSet
  mergeMapAttr = f: xs: builtins.foldl' (a: b: a // b) { } (builtins.map f xs);

  hasSubAttr = attrPath: attrset:
    let
      go = lib.foldl' (state: attr:
        if (state.result && builtins.isAttrs state.attrset
          && lib.hasAttr attr state.attrset) then {
            result = true;
            attrset = state.attrset.${attr};
          } else {
            result = false;
          }) {
            result = true;
            attrset = attrset;
          };
    in (go (lib.splitString "." attrPath)).result;
}
