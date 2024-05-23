{ custom, ... }:

{
  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    displayManager.defaultSession = "none+xmonad";

    xserver = {
      enable = true;
      xkb = {
        layout = custom.default.layout;
        options = "caps:ctrl_modifier";
      };

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
    };
  };
  systemd.services.upower.enable = true;
}
