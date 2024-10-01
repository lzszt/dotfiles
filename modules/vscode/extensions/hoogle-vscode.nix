{ pkgs, ... }:
{
  extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "jcanero";
    name = "hoogle-vscode";
    version = "0.0.7";
    sha256 = "sha256-QU2psApUsSd70Lol6FbQopoT5x/raA5FOgLJsbO7qlk=";
  };
  userSettings.hoogle-vscode.useCabalDependencies = true;
  default = true;
}
