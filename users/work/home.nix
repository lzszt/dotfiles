{
  custom,
  pkgs,
  inputs,
  system,
  ...
}:
let
  email = "felix.leitz@active-group.de";
  ldapUser = "leitz";
in
{
  imports = [
    ../../modules
    ../../modules/base.nix
  ];

  programs = {
    mercurial = {
      enable = true;
      userEmail = email;
      userName = "Felix Leitz";
    };
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
          passwordCommand = "";
          mbsync = {
            enable = true;
            create = "maildir";
          };
        };
      };
    };
  };

  modules =
    let
      customAliases = fishOnly: {
        illc = ''
          sudo ${pkgs.openconnect}/bin/openconnect --protocol=anyconnect \
          --user=ext_activegroup2 vpn.egv.at \
          -s "${pkgs.vpn-slice}/bin/vpn-slice --no-host-names --no-ns-hosts 10.0.0.0/8 rdsivo.egv.at"
        '';

        virt-leibniz = "virt-manager -c 'qemu+ssh://leibniz/system'";
        virt-lovelace = "virt-manager -c 'qemu+ssh://lovelace/system'";

        tt = "timetracking";
        sc = "shortcuts";

        jit = fishOnly {
          expansion = "google-chrome-stable 'https://jitsi.active-group.de/%' &; disown";
        };

        mst = fishOnly {
          expansion = "teams-for-linux --url '%'";
        };
      };
    in
    {
      vscode.extensions = {
        # org-mode.enable = true;
        agda-mode.enable = true;
        todo-md.user-settings.todomd = {
          defaultFile = "/home/leitz/Syncthing Folder/todo.md";
          defaultArchiveFile = "/home/leitz/Syncthing Folder/todo.archive.md";
        };
        git-worktrees.enable = true;
      };
      fish = {
        enable = true;
        inherit customAliases;
      };
      git.email = email;
      timetracking.enable = true;
      desktop = {
        xmonad = {
          enable = true;
          workspaces = with pkgs.lib.my; [
            (mkWorkspace "chat" [
              "mattermost-desktop"
              "teams-for-linux"
            ])
            (mkWorkspace "home" [ "firefox" ])
            (mkWorkspace "dev" [ "code" ])
            (mkWorkspace "remote" [ ])
            (mkWorkspace "5" [ "keepassxc" ])
            (mkWorkspace "cal" [ "thunderbird" ])
            (mkWorkspace "com" [ "linphone" ])
            (mkWorkspace "8" [ ])
            (mkWorkspace "9" [
              "remmina"
              "alacritty"
            ])
          ];
        };
        polybar = {
          enable = true;
          custom-modules.left = [ "work-stats" ];
        };
      };

      mattermost = {
        enable = true;
        config = {
          version = 3;
          teams = [
            {
              url = "https://mattermost.active-group.de";
              name = "AG";
              tabs = [
                { name = "TAB_MESSAGING"; }
                { name = "TAB_PLAYBOOKS"; }
              ];
            }
          ];
        };
      };

      bash = {
        inherit customAliases;
      };

      ssh = {
        enable = true;
        matchBlocks = custom.secrets.ag.sshMatchBlocks // {
          apps = {
            host = "apps";
            hostname = "apps.lzszt.info";
            user = "root";
            compression = true;
          };
        };
      };
      cloneRepos = {
        enable = true;
        git.repos =
          let
            gitlabAG = "ssh://git@gitlab.active-group.de:1022/";
          in
          {
            ag = {
              equals.url = gitlabAG + "ag/equals-web.git";
              it-configs.url = gitlabAG + "ag-sensitive/it-configs.git";
              siemens-anomaly-app.url = gitlabAG + "ag/siemens-anomaly-app.git";
              isaqb-foundation.url = gitlabAG + "ag/isaqb-foundation.git";
              howto.url = gitlabAG + "ag/howto";
              angebote.url = gitlabAG + "ag/angebote";
            };

            dotfile-secrets.url = "git@github.com:lzszt/dotfile-secrets.git";
            home-manager.url = "git@github.com:lzszt/home-manager.git";
            nixpkgs.url = "git@github.com:lzszt/nixpkgs.git";
          };

        # subversion.repos = [{
        #   dir = ag + "/stundenzettel";
        #   url = "https://svn.active-group.de/svn/controlling/2023/Stundenzettel";
        #   name = "2023";
        # }];
      };

      vscext-init.enable = true;
    };

  home.packages =
    let
      sieve =
        let
          sieve-version = "0.6.1";
        in
        pkgs.appimageTools.wrapType2 {
          pname = "sieve";
          version = sieve-version;
          src = pkgs.fetchurl {
            url = "https://github.com/thsmi/sieve/releases/download/${sieve-version}/sieve-${sieve-version}-linux-x64.AppImage";
            sha256 = "sha256-tiA+wp7oMGmK3UPJRQ3NBrqVT+D0B6sT+npXUZ7zok8=";
          };
        };
      pkgs2411 = (
        import inputs.nixpkgs-2411 {
          config.allowUnfree = true;
          inherit system;
        }
      );
    in
    with pkgs;
    [

      custom.secrets.ag.shortcuts
      pkgs2411.linphone
      teams-for-linux

      fd

      pkgs2411.apache-directory-studio

      pkgs2411.remmina
      openconnect
      vpn-slice

      virt-manager

      docker
      docker-compose

      sieve
    ];
  home.stateVersion = "22.11";
}
