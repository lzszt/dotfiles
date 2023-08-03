{ config, pkgs, lib, ... }:

let cfg = config.modules.desktop.xmonad;
in {

  options.modules.desktop.xmonad = {
    enable = lib.mkEnableOption "xmonad";
    workspaces = lib.mkOption { default = [ ]; };
  };

  config = lib.mkIf cfg.enable {
    xsession.windowManager.xmonad = {
      config = ./xmonad.hs;
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: [ hp.dbus hp.monad-logger ];
    };
    home.file.".xmonad/workspaces".text = let
      generateWorkspace = workspaceId: apps:
        "${workspaceId}:${builtins.concatStringsSep "," apps}";
    in "${lib.concatLines (builtins.map
      (workspace: generateWorkspace workspace.workspaceId workspace.apps)
      cfg.workspaces)}";
  };
}
