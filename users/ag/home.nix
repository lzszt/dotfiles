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
  };

  modules = {
    git.email = "felix.leitz@active-group.de";
    desktop.xmonad.enable = true;
    desktop.polybar.enable = true;
  };

  home.packages = with pkgs; [
    thunderbird
    keepassxc
    mattermost-desktop
    pavucontrol
    jitsi-meet-electron
    linphone
    lazygit
    ripgrep
    fd
    google-chrome
    firefox

    apache-directory-studio

    ghc
    haskell-language-server
    ormolu

    remmina
    openconnect
    vpn-slice
    teams

    htop

    docker
    docker-compose
  ];
  home.activation = let
    ag = "ag";
    gitlabAG = "ssh://git@gitlab.active-group.de:1022";
    repos_to_clone = [
      {
        dir = ag;
        url = gitlabAG + "/ag/equals-web.git";
        name = "equals";
      }
      {
        dir = ag;
        url = gitlabAG + "/ag-sensitive/it-configs.git";
        name = "it-configs";
      }
      {
        dir = ag;
        url = gitlabAG + "/ag/siemens-anomaly-app.git";
        name = "siemens-anomaly-app";
      }
      {
        dir = ag;
        url = gitlabAG + "/ag/siemens-anomaly-app.git";
        name = "siemens-anomaly-app";
      }
      {
        dir = ag;
        url = gitlabAG + "/ag/isaqb-foundation.git";
        name = "isaqb-foundation";
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
}
