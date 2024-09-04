{ pkgs, ... }:
{
  extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "berberman";
    name = "vscode-cabal-fmt";
    version = "0.0.3";
    sha256 = "sha256-TY1fxdhjktsdRDqWAioUKSBd8I0ztroPIeC4Cv+NzE0=";
  };
  default = true;
}
