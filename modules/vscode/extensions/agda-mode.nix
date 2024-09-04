{ pkgs, ... }:
{
  extension = pkgs.vscode-extensions.banacorn.agda-mode;
  user-settings.agdaMode.view.panelMountPosition = "right";
  keybindings = [
    {
      key = "ctrl+x ctrl+=";
      command = "-agda-mode.lookup-symbol";
      when = "!terminalFocus && editorLangId == 'agda' || !terminalFocus && editorLangId == 'lagda-md' || !terminalFocus && editorLangId == 'lagda-rst' || !terminalFocus && editorLangId == 'lagda-tex'";
    }
    {
      key = "ctrl+j ctrl+h";
      command = "agda-mode.helper-function-type[Normalised]";
      when = "editorLangId == 'agda' || editorLangId == 'lagda-md' || editorLangId == 'lagda-rst' || editorLangId == 'lagda-tex'";
    }
    {
      key = "ctrl+y ctrl+h";
      command = "-agda-mode.helper-function-type[Normalised]";
      when = "editorLangId == 'agda' || editorLangId == 'lagda-md' || editorLangId == 'lagda-rst' || editorLangId == 'lagda-tex'";
    }
  ];
}
