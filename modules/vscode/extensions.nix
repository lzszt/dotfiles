{
  inputs,
  system,
  pkgs,
  lib,
  sshCfg,
  ...
}:
pkgs.lib.my.mergeMapAttr (extension: {
  ${lib.removeSuffix ".nix" extension} = import ./extensions/${extension} {
    inherit
      pkgs
      inputs
      system
      lib
      sshCfg
      ;
  };
}) (pkgs.lib.my.readFileNames ./extensions)
