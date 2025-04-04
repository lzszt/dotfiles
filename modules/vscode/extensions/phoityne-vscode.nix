{ pkgs, ... }:
{
  extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "phoityne";
    name = "phoityne-vscode";
    version = "0.0.30";
    sha256 = "sha256-5WMvN0Q/Vtriwjgsu7hdjgPxn8qkniu4FQWuQxbnUrQ=";
  };
  default = true;
}
