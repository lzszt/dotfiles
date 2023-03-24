{ config, pkgs, lib, ... }:

let cfg = config.modules.desktop.xmobar;
in {

  options.modules.desktop.xmobar = { enable = lib.mkEnableOption "xmobar"; };

  config = lib.mkIf cfg.enable {
    home.file."${config.xdg.configHome}/xmobar/xmobar.hs".source = ./xmobar.hs;
  };
}
