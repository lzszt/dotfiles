{ config, lib, pkgs, stdenv, ... }:
let email = "felix.leitz@active-group.de";
in {
  imports = [ ../../modules ../../modules/base.nix ];

  programs = {
    mercurial = {
      enable = true;
      userEmail = email;
      userName = "Felix Leitz";
    };
  };

  modules = {
    git.email = email;
    desktop = {
      xmonad.enable = true;
      polybar.enable = true;
    };
    rofi.enable = true;
    vscode.enable = true;
    firefox.enable = true;
    bash.enable = true;
    direnv.enable = true;
    cloneRepos = {
      enable = true;
    cloneRepos = let ag = "ag";
    in {
      enable = true;
      git.repos = let gitlabAG = "ssh://git@gitlab.active-group.de:1022";
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
    mattermost-desktop
    jitsi-meet-electron
    linphone

    fd

    jetbrains.datagrip

    apache-directory-studio

    remmina
    openconnect
    vpn-slice
    teams

    docker
    docker-compose
  ];
  home.stateVersion = "22.11";
}
