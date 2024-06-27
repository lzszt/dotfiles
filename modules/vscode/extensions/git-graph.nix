{ pkgs, ... }:
{
  extension = pkgs.vscode-extensions.mhutchie.git-graph;
  default = true;
  keybindings = [
    {
      key = "Ctrl+l";
      command = "-expandLineSelection";
      when = "textInputFocus";
    }
    {
      key = "Ctrl+l";
      command = "git-graph.view";
    }
  ];
}
