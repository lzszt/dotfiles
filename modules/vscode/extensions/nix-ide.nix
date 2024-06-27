{ pkgs, ... }:
{
  extension = pkgs.vscode-extensions.jnoortheen.nix-ide;
  user-settings.nix = {
    enableLanguageServer = true;
    serverPath = "${pkgs.nil}/bin/nil";
  };
  default = true;
}
