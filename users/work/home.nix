{
  custom,
  pkgs,
  inputs,
  system,
  config,
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

  age = {
    identityPaths = [ "/home/leitz/.ssh/id_ed25519" ];
    secrets.arbeitszeiten-api-key.file = ../../secrets/arbeitszeiten-api-key.age;
    secrets.abrechenbare-zeiten-api-key.file = ../../secrets/abrechenbare-zeiten-api-key.age;
  };

  active-group.timetracking = {
    enable = true;
    arbeitszeiten-token = config.age.secrets.arbeitszeiten-api-key.path;
    abrechenbare-zeiten-token = config.age.secrets.abrechenbare-zeiten-api-key.path;
  };

  modules =
    let
      customAliases = fishOnly: {
        illc = ''
          sudo ${pkgs.openconnect}/bin/openconnect --protocol=anyconnect \
          --user=ext_activegroup2 vpn.egv.at \
          -s "${pkgs.vpn-slice}/bin/vpn-slice --no-host-names --no-ns-hosts 10.0.0.0/8 rdsivo.egv.at"
        '';

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

      sync-labor = pkgs.writeScriptBin "sync-labor" ''
        ${custom.secrets.ag.shortcuts}/bin/shortcuts --generate-labor-report | tt-import-arbeitszeiten - --begin 2025-11-24
      '';

      sync-billable = pkgs.writeScriptBin "sync-billable" ''
        ${custom.secrets.ag.shortcuts}/bin/shortcuts --generate-billable-report | tt-import-abrechenbare-zeiten - --begin 2025-11-24
      '';
    in
    with pkgs;
    [
      sync-labor
      sync-billable

      custom.secrets.ag.shortcuts
      pkgs2411.linphone
      teams-for-linux

      fd

      apache-directory-studio

      remmina
      openconnect
      vpn-slice

      virt-manager

      docker
      docker-compose

      sieve
    ];
  home.stateVersion = "22.11";
}
