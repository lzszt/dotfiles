{ inputs, system, config, lib, pkgs, ... }:
let
  cfg = config.modules.vscode;

  userSettings = import ./user-settings.nix;

  snippets = import ./snippets.nix;
  extensions = import ./extensions.nix { inherit inputs system pkgs; };
in {
  options.modules.vscode = {
    enable = lib.mkEnableOption "vscode";
    extensions = lib.mkOption { default = [ ]; };
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      inherit userSettings;
      inherit (snippets) languageSnippets globalSnippets;
      extensions = extensions ++ cfg.extensions;
    };
  };
}
