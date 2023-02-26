pkgs:
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

in {
  "module/xkeyboard" = {
    type = "internal/xkeyboard";
    blacklist-0 = "num lock";
    label-layout = "%layout%";
    label-layout-foreground = "${colors.primary}";
    label-indicator-padding = 2;
    label-indicator-margin = 1;
    label-indicator-foreground = "${colors.background}";
    label-indicator-background = "${colors.secondary}";
  };
  "module/cpu" = {
    format = " <label>";
    format-background = "${colors.background}";
    format-foreground = "${colors.foreground}";
    format-padding = 2;
    interval = "0.5";
    label = "CPU %percentage%%";
    type = "internal/cpu";
  };
  "module/xmonad" = {
    type = "custom/script";
    exec = "${pkgs.xmonad-log}/bin/xmonad-log";
    tail = true;
  };

  "module/filesystem" = {
    type = "internal/fs";
    format = " <label>";
    format-background = "${colors.background}";
    format-foreground = "${colors.foreground}";
    format-padding = 2;
    format-margin = 0;
    mount-0 = "/";
    label-mounted = "%mountpoint% %percentage_used%%";
  };
  "module/audio" = {
    format-muted = " <label-muted>";
    format-muted-background = "${colors.background}";
    format-muted-foreground = "${colors.urgent}";
    format-muted-overline = "${colors.transparent}";
    format-muted-padding = 2;
    format-muted-margin = 0;
    format-muted-prefix = "";
    format-muted-prefix-foreground = "${colors.urgent}";
    format-volume = " <label-volume>";
    format-volume-background = "${colors.background}";
    format-volume-foreground = "${colors.foreground}";
    format-volume-padding = 2;
    format-volume-margin = 0;
    label-muted = "MUTED";
    label-volume = "%percentage%%";
    type = "internal/pulseaudio";
  };
  "module/date" = {
    format = "<label>";
    format-foreground = "${colors.foreground}";
    format-background = "${colors.background}";
    format-padding = 2;
    format-margin = 0;
    interval = 1;
    label = "%date% %time%";
    time = "%H:%M:%S";
    date = "%d %b %Y";
    type = "internal/date";
  };
  "module/memory" = {
    format = " <label>";
    format-background = "${colors.background}";
    format-foreground = "${colors.foreground}";
    format-padding = 2;
    format-margin = 0;
    interval = 3;
    label = "RAM %percentage_used%%";
    type = "internal/memory";
  };
  "module/eth" = {
    type = "internal/network";
    interface = "enp34s0";
    interface-type = "wired";
    label-connected = "%{F#F0C674}%{F-} %local_ip%";
  };
  "module/wlan" = {
    type = "internal/network";
    interface = "wlo1";
    interface-type = "wireless";
    label-connected = "%{F#F0C674}%%%{F-} %local_ip%";
  };
  "bar/bottom" = {
    width = "100%";
    height = "30pt";
    radius = 6;
    bottom = true;
    dpi = 96;
    monitor = "\${env:MONITOR:}";
    background = "${colors.background}";
    foreground = "${colors.foreground}";
    line-size = "3pt";
    border-size = "4pt";
    border-color = "${colors.transparent}";
    padding-left = 0;
    padding-right = 1;
    module-margin = 1;
    separator = "|";
    separator-foreground = "${colors.disabled}";
    font-0 = "Iosevka Nerd Font:size=15;4";
    font-1 = "FiraCode Nerd Font:style=Bold:size=19;4";
    font-2 = "Iosevka Nerd Font:style=Bold:size=15;4";
    modules-left = "filesystem memory cpu xmonad";
    modules-center = "date";
    modules-right = "audio xkeyboard wlan eth";
    cursor-click = "pointer";
    cursor-scroll = "ns-resize";
    enable-ipc = true;
    # display "above" window manager
    # wm-restack = "generic";
    # override-redirect = true;
  };
}
