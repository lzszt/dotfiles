{ config, lib, custom, pkgs, ... }:

{
  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    xserver = {
      enable = true;
      layout = custom.default.layout;

      displayManager.defaultSession = "none+xmonad";

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = ./../modules/xmonad/xmonad.hs;
        extraPackages = hp: [
          hp.dbus
          hp.monad-logger
          hp.xmonad-contrib
          hp.xmonad-dbus
        ];
      };
      xkbOptions = "caps:ctrl_modifier";
    };
  };
  systemd.services.upower.enable = true;
}
