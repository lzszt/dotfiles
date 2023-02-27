{ config, lib, pkgs, ... }:
let cfg = config.modules.rofi;
in {
  options.modules.rofi.enable = lib.mkEnableOption "rofi";
  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      theme = ./theme.rafi;
    };
  };
}
