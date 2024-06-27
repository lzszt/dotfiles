{ pkgs, ... }:
{
  extension = pkgs.vscode-extensions.mkhl.direnv;
  user-settings.direnv.restart.automatic = true;
  default = true;
}
