{ pkgs, ... }:
{
  extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "usernamehw";
    name = "todo-md";
    version = "2.30.0";
    sha256 = "sha256-bVq7/HhVDJJtO5rk1q5FYswpYMPcvasvUYf5WUItJqc=";
  };
  user-settings.todomd = {
    addCreationDate = true;
    creationDateIncludeTime = true;
    completionDateIncludeTime = true;
  };
  default = true;
}
