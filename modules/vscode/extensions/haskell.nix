{ pkgs, ... }:
{
  extension = pkgs.vscode-extensions.haskell.haskell;
  user-settings.haskell = {
    formattingProvider = "ormolu";
    manageHLS = "PATH";
  };
  default = true;
}
