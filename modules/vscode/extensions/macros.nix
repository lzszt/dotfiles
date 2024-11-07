{ pkgs, ... }:
{
  extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "geddski";
    name = "macros";
    version = "1.2.1";
    sha256 = "sha256-R6xBayBqDmatyk30emJOjqJNzoZyMJhcuTAJIeXuDJY=";
  };
  default = true;

  user-settings.macros = {
    rerunCommand = [
      "workbench.action.showCommands"
      "workbench.action.acceptSelectedQuickOpenItem"
    ];
  };

  keybindings = [
    {
      key = "ctrl+alt+shift+meta+r";
      command = "macros.rerunCommand";
    }
  ];
}
