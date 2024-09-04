{
  inputs,
  system,
  pkgs,
  lib,
  config,
  ...
}:
pkgs.lib.my.mergeMapAttr (extension: {
  ${lib.removeSuffix ".nix" extension} = import ./extensions/${extension} {
    inherit
      pkgs
      inputs
      system
      lib
      config
      ;
  };
}) (pkgs.lib.my.readFileNames ./extensions)
