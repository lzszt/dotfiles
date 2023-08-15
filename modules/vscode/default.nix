{ inputs, system, config, lib, pkgs, ... }:
let
  cfg = config.modules.vscode;
  sshCfg = config.modules.ssh;

  userSettings = import ./user-settings.nix { inherit lib sshCfg; };

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
      mutableExtensionsDir = false;
      inherit userSettings;
      inherit (snippets) languageSnippets globalSnippets;
      extensions = extensions ++ cfg.extensions;
    };
  };
}
