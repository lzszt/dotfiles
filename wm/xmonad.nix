{ config, lib, pkgs, ... }:

{
  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    xserver = {
      enable = true;
      layout = "us";

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
