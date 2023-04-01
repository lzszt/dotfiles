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
    ssh = {
      enable = true;
      matchBlocks = (inputs.dotfile-secrets.packages.${system}.agSsh {
        inherit lib;
      }).agSshMatchBlocks;
    };
    cloneRepos = let ag = "ag";
    in {
      enable = true;
      git.repos = let gitlabAG = "ssh://git@gitlab.active-group.de:1022";
      in {
        ag = {
          equals.url = gitlabAG + "/ag/equals-web.git";
          it-configs.url = gitlabAG + "/ag-sensitive/it-configs.git";
          siemens-anomaly-app.url = gitlabAG + "/ag/siemens-anomaly-app.git";
          isaqb-foundation.url = gitlabAG + "/ag/isaqb-foundation.git";
          # howto.url = gitlabAG + "ag/howto";
        };
      };
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

    virt-manager

    docker
    docker-compose
  ];
  home.stateVersion = "22.11";
}
