{
  inputs,
  system,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.vscode;

  userSettings = import ./user-settings.nix;

  snippets = import ./snippets.nix;
  extensions = import ./extensions.nix {
    inherit
      inputs
      system
      pkgs
      lib
      config
      ;
  };
  defaultKeybindings = import ./keybindings.nix;

  allKeybindings =
    defaultKeybindings
    ++ (lib.concatMap (ext: ext.keybindings or [ ]) (
      lib.attrValues (lib.filterAttrs (extName: ext: cfg.extensions.${extName}.enable) extensions)
    ));

  allExtensions =
    lib.flatten (
      lib.mapAttrsToList (
        extName: ext: if cfg.extensions.${extName}.enable then [ ext.extension ] else [ ]
      ) extensions
    )
    ++ cfg.extensions.custom;

  allUserSettings =
    userSettings
    // (pkgs.lib.my.mergeMapAttr (ext: ext.user-settings or { }) (
      lib.attrValues (lib.filterAttrs (extName: ext: cfg.extensions.${extName}.enable) extensions)
    ));
in
{
  options.modules.vscode = {
    enable = lib.mkEnableOption "vscode";
    extensions =
      {
        custom = lib.mkOption { default = [ ]; };
      }
      // (lib.mapAttrs (extName: ext: {
        enable = (lib.mkEnableOption "${extName}") // {
          default = ext.default or false;
        };
      }) extensions);
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      mutableExtensionsDir = false;
      keybindings = allKeybindings;
      inherit (snippets) languageSnippets globalSnippets;
      userSettings = allUserSettings;
      extensions = allExtensions;
    };
  };
}
