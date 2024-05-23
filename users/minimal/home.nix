{ pkgs, ... }:
let
  email = "felix.leitz92@gmail.com";
in
{
  imports = [
    ../../modules
    ../../modules/base.nix
  ];

  modules = {
    git.email = email;
    fish.enable = true;
    neomutt.enable = true;
    desktop = {
      xmonad = {
        enable = true;
        workspaces = with pkgs.lib.my; [
          (mkWorkspace "home" [ "firefox" ])
          (mkWorkspace "dev" [ "code" ])
          (mkWorkspace "stuff" [ "keepassxc" ])
          (mkWorkspace "4" [ ])
          (mkWorkspace "5" [ ])
          (mkWorkspace "6" [ ])
          (mkWorkspace "7" [ ])
          (mkWorkspace "obs" [ "obsidian" ])
          (mkWorkspace "9" [ ])
        ];
      };
      polybar.enable = true;
    };

    ssh.matchBlocks =
      let
        mkLzsztInfoSsh = subdomain: {
          host = subdomain;
          hostname = "${subdomain}.lzszt.info";
          user = "root";
          compression = true;
        };
      in
      {
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

        "mail" = mkLzsztInfoSsh "mail";
      };
  };

  home.packages = with pkgs; [
    signal-desktop
    discord

    steam
  ];

  home.stateVersion = "22.11";
}
