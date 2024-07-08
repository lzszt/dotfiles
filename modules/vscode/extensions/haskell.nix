{ pkgs, ... }:
{
  extension = pkgs.vscode-extensions.haskell.haskell;
  user-settings.haskell = {
    formattingProvider = "";
    manageHLS = "PATH";
    openDocumentationInHackage = false;
    openSourceInHackage = false;
  };
  default = true;
}
