{ pkgs, ... }:
{
  extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "vscode-org-mode";
    name = "org-mode";
    version = "1.0.0";
    sha256 = "sha256-o9CIjMlYQQVRdtTlOp9BAVjqrfFIhhdvzlyhlcOv5rY=";
  };
}
