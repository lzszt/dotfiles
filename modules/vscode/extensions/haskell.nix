inputs@{ pkgs, ... }:
{
  extension = pkgs.vscode-extensions.haskell.haskell;
  user-settings.haskell = {
    formattingProvider = "";
    manageHLS = "PATH";
    openDocumentationInHackage = false;
    openSourceInHackage = false;
  };
  depends-on = [ (import ./language-haskell.nix inputs) ];
  default = true;
}
