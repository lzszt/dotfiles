{ pkgs, ... }:
{
  extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "usernamehw";
    name = "todo-md";
    version = "2.30.0";
    sha256 = "sha256-bVq7/HhVDJJtO5rk1q5FYswpYMPcvasvUYf5WUItJqc=";
  };
  user-settings.todomd = {
    defaultFile = "/home/leitz/Sync/todo.md";
    defaultArchiveFile = "/home/leitz/Sync/todo.archive.md";
    addCreationDate = true;
    creationDateIncludeTime = true;
    completionDateIncludeTime = true;
    autoArchiveTasks = true;
  };
  default = true;
}
