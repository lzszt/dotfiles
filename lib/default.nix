{ lib, ... }:

{
  # (a -> AttrSet) -> [a] -> AttrSet
  mergeMapAttr = f: xs: xs |> builtins.map f |> builtins.foldl' (a: b: a // b) { };

  hasSubAttr =
    attrPath: attrset:
    let
      go =
        lib.foldl'
          (
            state: attr:
            if (state.result && builtins.isAttrs state.attrset && lib.hasAttr attr state.attrset) then
              {
                result = true;
                attrset = state.attrset.${attr};
              }
            else
              { result = false; }
          )
          {
            result = true;
            attrset = attrset;
          };
    in
    (attrPath |> lib.splitString "." |> go).result;

  mkWorkspace = workspaceId: apps: { inherit workspaceId apps; };

  readFileNames =
    path:
    path |> builtins.readDir |> lib.filterAttrs (_: type: type == "regular") |> builtins.attrNames;
}
