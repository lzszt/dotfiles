{ pkgs, ... }:
{
  extension = pkgs.vscode-extensions.justusadam.language-haskell;
  default = true;
}
