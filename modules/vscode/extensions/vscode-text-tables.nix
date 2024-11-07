{ pkgs, rebind, ... }:
{
  extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "romanpeshkov";
    name = "vscode-text-tables";
    version = "0.1.5";
    sha256 = "sha256-xUj8kA824wM99PJzoUtJAAlkiJG0IipwKGrl+ck8TJQ=";
  };
  default = true;
  keybindings = pkgs.lib.concatMap rebind [
    {
      oldKey = "Ctrl+Q Space";
      newKey = "Ctrl+Shift+Q Space";
      command = "text-tables.clearCell";
    }
    {
      oldKey = "Ctrl+Q Ctrl+Q";
      newKey = "Ctrl+Shift+Q Ctrl+Q";
      command = "text-tables.tableModeOn";
      when = "editorFocus && !tableMode";
    }
    {
      oldKey = "Ctrl+Q Ctrl+Q";
      newKey = "Ctrl+Shift+Q Ctrl+Q";
      command = "text-tables.tableModeOff";
      when = "editorFocus && tableMode";
    }
    {
      oldKey = "Ctrl+Q Ctrl+F";
      newKey = "Ctrl+Shift+Q Ctrl+F";
      command = "text-tables.formatUnderCursor";
    }
  ];
}
