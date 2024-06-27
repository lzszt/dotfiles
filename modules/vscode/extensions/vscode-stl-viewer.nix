{ pkgs, ... }:
{
  extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "mtsmfm";
    name = "vscode-stl-viewer";
    version = "0.3.0";
    sha256 = "sha256-1xQl+5PMAsSjf9y25/G63Z5YYj8mQMPOuDSVY4YBukc=";
  };
  user-settings.stlViewer = {
    showAxes = true;
    showInfo = true;
    showBoundingBox = true;
    meshMaterialType = "normal";
    viewOffset = 100;
  };
}
