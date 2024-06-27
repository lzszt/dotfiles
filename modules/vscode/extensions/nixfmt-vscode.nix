{ pkgs, ... }:
{
  extension = pkgs.vscode-extensions.brettm12345.nixfmt-vscode;
  default = true;
}
