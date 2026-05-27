{ pkgs, rebind, ... }:
{
  extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "tompollak";
    name = "lazygit-vscode";
    version = "0.1.26";
    sha256 = "sha256-WvgP4Etxx6Us5IveMumWIylrVrzlCa6Hbl4+gjFVgnU=";
  };
  default = true;
  keybindings = pkgs.lib.concatMap rebind [
    {
      oldKey = "Ctrl+Shift+L";
      newKey = "Ctrl+K Ctrl+L";
      command = "lazygit-vscode.toggle";
    }
  ];
}
