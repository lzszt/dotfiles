{ config, lib, pkgs, stdenv, ... }:
let email = "felix.leitz92@gmail.com";
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
      git.repos = {
        dotfile-secrets.url = "git@github.com:lzszt/dotfile-secrets.git";
        projects = {
          it.url = "git@gitlab.com:Zwiebeljunge/it.git";
          haskellmode.url = "git@gitlab.com:Zwiebeljunge/haskellmode.git";
          home-manager.url = "git@github.com:lzszt/home-manager.git";
          nixpkgs.url = "git@github.com:NixOS/nixpkgs.git";
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
    signal-desktop
    discord

    docker
    docker-compose
    jetbrains.datagrip

    steam

    (pkgs.callPackage ./prusa-slicer-alpha.nix { })

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
