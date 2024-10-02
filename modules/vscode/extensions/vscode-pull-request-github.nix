{ pkgs, ... }:
{
  extension = pkgs.vscode-extensions.github.vscode-pull-request-github;
  default = true;
}
