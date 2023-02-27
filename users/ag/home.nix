{ config, lib, pkgs, stdenv, ... }: {
  programs.home-manager.enable = true;
  home.stateVersion = "22.11";
  imports = [ ../../modules ];

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };

  modules = {
    git.email = "felix.leitz@active-group.de";
    desktop = {
      xmonad.enable = true;
      polybar.enable = true;
    };
    rofi.enable = true;
    firefox.enable = true;
    cloneRepos = {
      enable = true;
      repos = let
        ag = "ag";
        gitlabAG = "ssh://git@gitlab.active-group.de:1022";
      in [
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
    };
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
}
