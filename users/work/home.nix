{ inputs, system, config, lib, pkgs, stdenv, ... }:
let
  email = "felix.leitz@active-group.de";
  ldapUser = "leitz";
in {
  imports = [ ../../modules ../../modules/base.nix ];

  programs = {
    mercurial = {
      enable = true;
      userEmail = email;
      userName = "Felix Leitz";
    };
    mbsync.enable = true;
    msmtp.enable = true;
  };

  accounts = {
    email = {
      accounts = {
        work = {
          address = email;
          userName = ldapUser;
          imap.host = "imap.active-group.de";
          smtp.host = "smtp.active-group.de";
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

  modules = {
    fish.enable = true;
    git.email = email;
    neomutt.enable = true;
    desktop = {
      xmonad.enable = true;
      polybar.enable = true;
    };

    vscode.enable = true;
    bash.customAliases = {
      illc = ''
        sudo ${pkgs.openconnect}/bin/openconnect --protocol=anyconnect \
        --user=ext_activegroup2 vpn.egv.at \
        -s "${pkgs.vpn-slice}/bin/vpn-slice --no-host-names --no-ns-hosts 10.0.0.0/8 rdsivo.egv.at"
      '';
      illr = "/home/leitz/ag/illwerke/illwerke_remote";
    };

    ssh = {
      enable = true;
      matchBlocks = (inputs.dotfile-secrets.packages.${system}.agSsh {
        inherit lib;
      }).agSshMatchBlocks;
    };
    cloneRepos = {
      enable = true;
      git.repos = let gitlabAG = "ssh://git@gitlab.active-group.de:1022/";
      in {
        ag = {
          equals.url = gitlabAG + "ag/equals-web.git";
          it-configs.url = gitlabAG + "ag-sensitive/it-configs.git";
          siemens-anomaly-app.url = gitlabAG + "ag/siemens-anomaly-app.git";
          isaqb-foundation.url = gitlabAG + "ag/isaqb-foundation.git";
          howto.url = gitlabAG + "ag/howto";
          angebote.url = gitlabAG + "ag/angebote";
        };

        dotfile-secrets.url = "git@github.com:lzszt/dotfile-secrets.git";
      };

      # subversion.repos = [{
      #   dir = ag + "/stundenzettel";
      #   url = "https://svn.active-group.de/svn/controlling/2023/Stundenzettel";
      #   name = "2023";
      # }];
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

    virt-manager

    docker
    docker-compose

    sieve-connect
    thunderbird
  ];
  home.stateVersion = "22.11";
}
