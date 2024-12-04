{
  custom,
  pkgs,
  lib,
  custom-modules,
  ...
}:

let
  colors = {
    background = "#282A2E";
    background-alt = "#373B41";
    foreground = "#C5C8C6";
    primary = "#F0C674";
    secondary = "#8ABEB7";
    alert = "#A54242";
    disabled = "#707880";
    urgent = "#ff4500";
    transparent = "#00000000";
  };
  modules = import ./modules.nix {
    inherit
      custom
      pkgs
      colors
      lib
      ;
  };
in
{
  "global/wm" = {
    margin-bottom = 0;
    margin-top = 0;
  };

  "settings" = {
    compositing-background = "source";
    compositing-border = "over";
    compositing-foreground = "over";
    compositing-overline = "over";
    comppositing-underline = "over";
    pseudo-transparency = false;
    screenchange-reload = true;
  };

  "bar/bottom" = {
    bottom = true;
    modules-left = [
      "filesystem"
      "cpu"
      "memory"
    ] ++ custom-modules.left;
    modules-center = [
      "xmonad"
      "date"
    ];
    modules-right =
      [
        "xkeyboard"
        "audio"
        "mic"
      ]
      ++ (lib.optionals (pkgs.lib.my.hasSubAttr "polybar.ethernet" custom) (
        pkgs.lib.imap0 (index: _: "eth${toString index}") custom.polybar.ethernet
      ))
      ++ [
        "wlan"
        "battery"
      ];
    monitor = "\${env:MONITOR:}";
    background = "${colors.background}";
    foreground = "${colors.foreground}";
    fixed-center = true;
    font-0 = "JetBrainsMono Nerd Font:size=15;4";
    height = "30";
    locale = "en_US.UTF-8";
    offset-x = "0%";
    padding = "0";
    radius-top = "0";
    width = "100%";
    # display "above" window manager
    wm-restack = "generic";
    override-redirect = true;
    tray-position = "left";
  };

  "bar/compact" = {
    bottom = true;
    modules-left = custom-modules.left;
    modules-center = [
      "xmonad"
      "date"
    ];
    modules-right =
      [
        "audio"
        "mic"
      ]
      ++ [
        "wlan"
        "battery"
      ];
    monitor = "\${env:MONITOR:}";
    background = "${colors.background}";
    foreground = "${colors.foreground}";
    fixed-center = true;
    font-0 = "JetBrainsMono Nerd Font:size=15;4";
    height = "30";
    locale = "en_US.UTF-8";
    offset-x = "0%";
    padding = "0";
    radius-top = "0";
    width = "100%";
    # display "above" window manager
    wm-restack = "generic";
    override-redirect = true;
    tray-position = "left";
  };
}
// (
  with modules;
  xkeyboard
  // date
  // filesystem
  // cpu
  // audio
  // wlan
  // memory
  // xmonad
  // mic
  // work-stats
  // (lib.optionalAttrs (pkgs.lib.my.hasSubAttr "polybar.battery" custom) battery)
  // (lib.optionalAttrs (pkgs.lib.my.hasSubAttr "polybar.ethernet" custom) ethernets)
)
