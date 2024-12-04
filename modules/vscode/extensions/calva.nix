{ pkgs, ... }:
{
  extension = pkgs.vscode-extensions.betterthantomorrow.calva;
  user-settings.calva = {
    autoOpenJackInTerminal = false;
    showDocstringInParameterHelp = true;
  };
  default = true;
}
