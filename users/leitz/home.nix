{ config, lib, pkgs, stdenv, ... }:
let email = "felix.leitz92@gmail.com";
in {
  programs.home-manager.enable = true;
  home.stateVersion = "22.11";
  imports = [ ../../modules ];

  modules = {
    git.email = email;
    desktop = {
      xmonad.enable = true;
      polybar.enable = true;
    };
    rofi.enable = true;
    firefox.enable = true;
    bash = {
      enable = true;
      customAliases = {
        # nixos
        nrs = "sudo nixos-rebuild switch --flake ~/dotfiles/";
      };
    };
    direnv.enable = true;
    ssh = {
      enable = true;
      matchBlocks = let
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
    };
    cloneRepos = {
      enable = true;
      repos = let
        projects = "projects";
        haskellProjects = projects + "/haskell";
        gitlab = "git@gitlab.com:";
        github = "git@github.com:";
      in [
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
      ];
    };
  };

  home.packages = with pkgs; [
    thunderbird
    mutt
    keepassxc
    signal-desktop
    discord
    ghc
    haskell-language-server
    ormolu
    pavucontrol

    docker
    docker-compose

    google-chrome

    steam

    prusa-slicer

    alacritty

    rink

    ripgrep
    lazygit

    htop

    # Fonts
    font-awesome_5
    nerdfonts
  ];

  services = {
    dropbox = {
      enable = true;
      path = "${config.home.homeDirectory}/Dropbox";
    };
  };
}
