{ pkgs, ... }:
{
  extension = pkgs.vscode-extensions.waderyan.gitblame;
  user-settings.gitblame.ignoreWhitespace = true;
  default = true;
}
