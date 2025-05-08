{ pkgs, ... }:
{
  extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "GitWorktrees";
    name = "git-worktrees";
    version = "2.2.0";
    sha256 = "sha256-bk0poO9REcm7r3D0i9Z2DDsWjDlHXfI/kKvvwOwAgbg=";
  };
  user-settings.vsCodeGitWorktrees.add.autoPush = false;
}
