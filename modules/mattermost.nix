{ config, lib, pkgs, ... }:
let
  cfg = config.modules.mattermost;
  json = pkgs.formats.json { };
in {
  options.modules.mattermost = {
    enable = lib.mkEnableOption "mattermost";
    config = lib.mkOption {
      default = { };
      type = json.type;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.mattermost-desktop ];
    xdg.configFile."Mattermost/config.json".text = builtins.toJSON cfg.config;
  };
}
