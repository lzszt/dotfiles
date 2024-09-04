{
  inputs,
  system,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.vscode;
  allExtensions = pkgs.lib.my.mergeMapAttr (extension: {
    ${lib.removeSuffix ".nix" extension} = import ./extensions/${extension} {
      inherit
        pkgs
        inputs
        system
        lib
        config
        ;
    };
  }) (pkgs.lib.my.readFileNames ./extensions);

  installedExtensions =
    lib.flatten (
      lib.mapAttrsToList (
        extName: ext: if cfg.extensions.${extName}.enable then [ ext.extension ] else [ ]
      ) allExtensions
    )
    ++ cfg.extensions.custom;

  keybindings = (
    lib.concatMap (ext: ext.keybindings or [ ]) (
      lib.attrValues (lib.filterAttrs (extName: ext: cfg.extensions.${extName}.enable) allExtensions)
    )
  );

  userSettings = (
    pkgs.lib.my.mergeMapAttr (ext: ext.user-settings or { }) (
      lib.attrValues (lib.filterAttrs (extName: ext: cfg.extensions.${extName}.enable) allExtensions)
    )
  );

  enableOptions = (
    lib.mapAttrs (extName: ext: {
      enable = (lib.mkEnableOption "${extName}") // {
        default = ext.default or false;
      };
    }) allExtensions
  );
in
{
  inherit
    allExtensions
    installedExtensions
    keybindings
    userSettings
    enableOptions
    ;
}
