{ config, lib, pkgs, stdenv, ... }:
let
  email = "felix.leitz92@gmail.com";
  projects = "projects";
  haskellProjects = projects + "/haskell";
in {
  imports = [ ../../modules ../../modules/base.nix ];

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
        uni-mail = {
          address = "felix.leitz@student.uni-tuebingen.de";
          userName = "zxmfh96";
          imap.host = "mailserv.uni-tuebingen.de";
          smtp.host = "smtpserv.uni-tuebingen.de";
          realName = "Felix Leitz";
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
    git.email = email;
    neomutt.enable = true;
    desktop = {
      xmonad.enable = true;
      polybar.enable = true;
    };

    vscode.enable = true;
    bash.customAliases = {
      # nixos
      nrs = "sudo nixos-rebuild switch --flake ~/dotfiles/";
    };

    ssh.matchBlocks = let
      mkLzsztInfoSsh = subdomain: {
        host = subdomain;
        hostname = "${subdomain}.lzszt.info";
        user = "root";
        compression = true;
      };

    in {
      "gitlab-runner-1" = {
        host = "gitlab-runner-1";
        user = "root";
        proxyCommand = "ssh root@turing -W %h:%p";
      };

      "turing" = {
        host = "turing";
        user = "root";
        compression = true;
      };

      "grafana" = mkLzsztInfoSsh "grafana";

      "apps" = mkLzsztInfoSsh "apps";
    };

    cloneRepos = {
      enable = true;
      git.repos = let
        gitlab = "git@gitlab.com:";
        github = "git@github.com:";
      in [
        {
          dir = ".";
          url = github + "lzszt/dotfile-secrets.git";
          name = "dotfile-secrets";
        }
        {
          dir = haskellProjects;
          url = github + "lzszt/config.git";
          name = "config";
        }
        {
          dir = haskellProjects;
          url = github + "lzszt/polysemy-utils.git";
          name = "polysemy-utils";
        }
        {
          dir = haskellProjects;
          url = gitlab + "leitz-projects/shortcuts.git";
          name = "shortcuts";
        }
        {
          dir = projects;
          url = gitlab + "Zwiebeljunge/it.git";
          name = "it";
        }
        {
          dir = haskellProjects;
          url = gitlab + "leitz-projects/expense-tracker.git";
          name = "expense-tracker";
        }
        {
          dir = haskellProjects;
          url = gitlab + "leitz-projects/bildschirm.git";
          name = "BILDschirm";
        }
        {
          dir = haskellProjects;
          url = gitlab + "leitz-projects/strava-runner.git";
          name = "strava-runner";
        }
        {
          dir = haskellProjects;
          url = gitlab + "Zwiebeljunge/stravaapi.git";
          name = "strava-api";
        }
        {
          dir = haskellProjects;
          url = gitlab + "leitz-projects/homeautomation.git";
          name = "home-automation";
        }
        {
          dir = haskellProjects;
          url = gitlab + "leitz-projects/3d.git";
          name = "3d";
        }
        {
          dir = projects;
          url = gitlab + "Zwiebeljunge/haskellmode.git";
          name = "haskellmode";
        }
        {
          dir = projects;
          url = github + "lzszt/home-manager.git";
          name = "home-manager";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    signal-desktop
    discord

    docker
    docker-compose
    jetbrains.datagrip

    steam

    prusa-slicer

    rink
  ];

  services = {
    dropbox = {
      enable = true;
      path = "${config.home.homeDirectory}/Dropbox";
    };
  };
  home.stateVersion = "22.11";
}
