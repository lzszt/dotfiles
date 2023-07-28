{ inputs, system, config, lib, pkgs, ... }:
let
  cfg = config.modules.vscode;

  userSettings = {
    # editor settings
    "editor.minimap.enabled" = false;
    "editor.tabSize" = 2;
    "editor.formatOnSave" = true;
    # telemetry settings
    "telemetry.telemetryLevel" = "off";
    # miscellaneous settings
    "workbench.colorThem" = "Default Dark+";
    "window.zoomLevel" = 1;
    # git settings
    "git.confirmSync" = false;
    "git.autofetch" = true;

    # explorer settings
    "explorer.confirmDragAndDrop" = false;

    # default haskell settings
    "haskell.formattingProvider" = "ormolu";
    "haskell.manageHLS" = "PATH";

    # stl viewer settings
    "stlViewer.showAxes" = true;
    "stlViewer.showInfo" = true;
    "stlViewer.showBoundingBox" = true;
    "stlViewer.meshMaterialType" = "normal";
    "stlViewer.viewOffset" = 100;
  };

  snippets = import ./snippets.nix;
  extensions = import ./extensions.nix { inherit inputs system pkgs; };
in {
  options.modules.vscode = { enable = lib.mkEnableOption "vscode"; };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      inherit userSettings extensions;
      inherit (snippets) languageSnippets globalSnippets;
    };
  };
}
