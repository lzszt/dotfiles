{ pkgs, ... }:
{
  extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "analytic-signal";
    name = "preview-tiff";
    version = "1.0.1";
    sha256 = "sha256-S4RElLeeu2j6o/Lvj7wyGgjdGAGsyzeGJpdveLsEDkY=";
  };
}
