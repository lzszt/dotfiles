{ pkgs, ... }:
{
  extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "anthropic";
    name = "claude-code";
    version = "2.1.87";
    sha256 = "sha256-0brafiNuo6wRGWlGAOax3My9CrGKiGpDjFswuHFWt4M=";
  };
}

