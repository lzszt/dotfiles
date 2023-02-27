{ config, lib, pkgs, stdenv, ... }: {
  programs.home-manager.enable = true;
  home.stateVersion = "22.11";
  imports = [ ../../programs ];

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    firefox = {
      enable = true;
      profiles.myprofile.extensions = [ ];
    };

  };

  modules = {
    git.email = "felix.leitz92@gmail.com";
    rofi.enable = true;
  };

  home.packages = with pkgs; [
    thunderbird
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

  home.activation = let
    projects = "projects";
    haskellProjects = projects + "/haskell";
    gitlab = "git@gitlab.com:";
    github = "git@github.com:";
    repos_to_clone = [
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
  in {
    cloneRepos = let
      cloneSingleRepo = repo: ''
        mkdir -p $HOME/${repo.dir}
        cd $HOME/${repo.dir}

        if [ ! -d $HOME/${repo.dir}/${repo.name} ]
        then
            $DRY_RUN_CMD ${pkgs.gitAndTools.gitFull}/bin/git clone ${repo.url} ${repo.name}
        else
            echo 'Not cloning ${repo.url} because it already exists.' 
        fi
      '';
      script = lib.concatLines (builtins.map cloneSingleRepo repos_to_clone);
    in lib.hm.dag.entryAfter [ "writeBoundary" ] script;
  };

  services = {
    dropbox = {
      enable = true;
      path = "${config.home.homeDirectory}/Dropbox";
    };
  };
}
