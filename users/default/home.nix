{ config, lib, pkgs, stdenv, ... }: {
  imports = [ ../minimal/home.nix ];

  accounts = {
    email = {
      accounts = {
        gmail = {
          address = "felix.leitz92@gmail.com";
          userName = "felix.leitz92@gmail.com";
          imap.host = "imap.gmail.com";
          smtp.host = "smtp.gmail.com";
          realName = "Felix Leitz";
          primary = true;
          neomutt.enable = true;
          passwordCommand = "";
          mbsync = {
            enable = true;
            create = "maildir";
          };
        };
      };
    };
  };

  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
  };

  modules = {
    vscode = {
      enable = true;
      extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
        publisher = "mtsmfm";
        name = "vscode-stl-viewer";
        version = "0.3.0";
        sha256 = "sha256-1xQl+5PMAsSjf9y25/G63Z5YYj8mQMPOuDSVY4YBukc=";
      }];
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
            expense-tracker.url =
              "git@gitlab.com:leitz-projects/expense-tracker.git";
            BILDschirm.url = "git@gitlab.com:leitz-projects/bildschirm.git";
            strava-runner.url =
              "git@gitlab.com:leitz-projects/strava-runner.git";
            strava-api.url = "git@gitlab.com:Zwiebeljunge/stravaapi.git";
            home-automation.url =
              "git@gitlab.com:leitz-projects/homeautomation.git";
            cad.url = "git@gitlab.com:leitz-projects/3d.git";
          };
        };
      };
    };
  };

  home.packages = with pkgs; [
    docker
    docker-compose
    jetbrains.datagrip

    prusa-slicer
    openscad-unstable

    teamviewer

    stellarium
  ];

  home.stateVersion = "22.11";
}
