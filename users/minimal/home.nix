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
          (mkWorkspace "med" [ "Grayjay" ])
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

        mkLocalSsh = subdomain: {
          host = subdomain;
          user = "root";
          compression = true;
        };
      in
      {

        "turing" = mkLocalSsh "turing";

        "apps" = mkLzsztInfoSsh "apps";
        "grafana" = mkLzsztInfoSsh "grafana";
        "immich" = mkLzsztInfoSsh "immich";
        "mail" = mkLzsztInfoSsh "mail";
        "valheim" = mkLzsztInfoSsh "valheim";
      };
  };

  home.packages = with pkgs; [
    signal-desktop
    discord

    steam
  ];

  home.stateVersion = "22.11";
}
