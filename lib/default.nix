{ lib, ... }:

{
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

  mkWorkspace = workspaceId: apps: { inherit workspaceId apps; };
}
