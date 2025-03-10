{
  inputs,
  system,
  pkgs,
  lib,
  config,
  rebind,
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
        rebind
        ;
    };
  }) (pkgs.lib.my.readFileNames ./extensions);

  extensionAndDeps =
    ext:
    let
      dependencyExts = lib.concatMap extensionAndDeps (ext.depends-on or [ ]);
    in
    [ ext ] ++ dependencyExts;

  enabledExtensions =
    lib.flatten (
      lib.mapAttrsToList (
        extName: ext: if cfg.extensions.${extName}.enable then extensionAndDeps ext else [ ]
      ) allExtensions
    )
    ++ lib.concatMap extensionAndDeps cfg.extensions.custom;

  installedExtensions = map (ext: ext.extension) enabledExtensions;

  keybindings = lib.concatMap (ext: ext.keybindings or [ ]) enabledExtensions;

  userSettings = pkgs.lib.my.mergeMapAttr (ext: ext.user-settings or { }) enabledExtensions;

  options = (
    lib.mapAttrs (extName: ext: {
      enable = (lib.mkEnableOption "${extName}") // {
        default = ext.default or false;
      };
      user-settings = (lib.mkOption { default = { }; });
    }) allExtensions
  );
in
{
  inherit
    allExtensions
    installedExtensions
    keybindings
    userSettings
    options
    ;
}
