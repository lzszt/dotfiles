{ pkgs, ... }:
{
  imports = [ ../minimal/home.nix ];

  modules = {
    vscode.extensions = {
      vscode-stl-viewer.enable = true;
      preview-tiff.enable = true;
      todo-md.user-settings.todomd = {
        defaultFile = "/home/leitz/Sync/todo.md";
        defaultArchiveFile = "/home/leitz/Sync/todo.archive.md";
      };
    };

    cloneRepos = {
      enable = true;
      git.repos = {
        dotfile-secrets.url = "git@github.com:lzszt/dotfile-secrets.git";
        projects = {
          it.url = "git@gitlab.com:Zwiebeljunge/it.git";
          haskellmode.url = "git@gitlab.com:Zwiebeljunge/haskellmode.git";
          home-manager.url = "git@github.com:lzszt/home-manager.git";
          nixpkgs.url = "git@github.com:lzszt/nixpkgs.git";
          haskell = {
            config.url = "git@github.com:lzszt/config.git";
            polysemy-utils.url = "git@github.com:lzszt/polysemy-utils.git";
            shortcuts.url = "git@gitlab.com:leitz-projects/shortcuts.git";
            expense-tracker.url = "git@gitlab.com:leitz-projects/expense-tracker.git";
            BILDschirm.url = "git@gitlab.com:leitz-projects/bildschirm.git";
            strava-runner.url = "git@gitlab.com:leitz-projects/strava-runner.git";
            strava-api.url = "git@gitlab.com:Zwiebeljunge/stravaapi.git";
            home-automation.url = "git@gitlab.com:leitz-projects/homeautomation.git";
            cad.url = "git@gitlab.com:leitz-projects/3d.git";
          };
        };
      };
    };

    vscext-init.enable = true;
  };

  home.packages = with pkgs; [
    docker
    docker-compose

    prusa-slicer
    openscad-unstable

    teamviewer

    stellarium
  ];

  home.stateVersion = "22.11";
}
