{ pkgs, rebind, ... }:
{
  extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "chaitanyashahare";
    name = "lazygit";
    version = "1.0.7";
    sha256 = "sha256-oz3mx6clOJb2Ur//kMzXaFNwmtn7R6KNK+CF1xgcJTs=";
  };
  default = true;
  keybindings = pkgs.lib.concatMap rebind [
    {
      oldKey = "Ctrl+G G";
      newKey = "Ctrl+K Ctrl+L";
      command = "lazygit.openLazygit";
    }
  ];
}
