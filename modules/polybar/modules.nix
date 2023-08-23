{ custom, pkgs, colors, ... }: {
  xkeyboard = {
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
  };
  date = {
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
  };
  filesystem = {
    "module/filesystem" = {
      type = "internal/fs";
      format = "<label>";
      format-background = "${colors.background}";
      format-foreground = "${colors.foreground}";
      format-padding = 2;
      format-margin = 0;
      mount-0 = "/";
      label-mounted = "%mountpoint% %percentage_used%%";
    };
  };
  cpu = {
    "module/cpu" = {
      format = "<label>";
      format-background = "${colors.background}";
      format-foreground = "${colors.foreground}";
      format-padding = 2;
      interval = "0.5";
      label = " %percentage%%";
      type = "internal/cpu";
    };
  };
  battery = {
    "module/battery" = {
      type = "internal/battery";
      adapter = "AC0";
      animation-charging-0 = "";
      animation-charging-1 = "";
      animation-charging-2 = "";
      animation-charging-3 = "";
      animation-charging-4 = "";
      animation-charging-framerate = 500;
      battery = custom.polybar.battery;
      format-charging = "󱐥 <animation-charging> <label-charging>";
      format-charging-padding = 1;
      format-discharging = "<ramp-capacity> <label-discharging>";
      format-discharging-padding = 1;
      format-full-padding = 1;
      full-at = 100;
      label-charging = "%percentage%% +%consumption%W";
      label-discharging = "%percentage%% -%consumption%W";
      label-full = " ";
      poll-interval = 2;
      ramp-capacity-0 = "";
      ramp-capacity-1 = "";
      ramp-capacity-2 = "";
      ramp-capacity-3 = "";
      ramp-capacity-4 = "";
    };
  };
  audio = {
    "module/audio" = {
      format-muted = "<label-muted>";
      format-muted-background = "${colors.background}";
      format-muted-foreground = "${colors.urgent}";
      format-muted-overline = "${colors.transparent}";
      format-muted-padding = 2;
      format-muted-margin = 0;
      format-muted-prefix-foreground = "${colors.urgent}";
      format-volume = " <label-volume>";
      format-volume-background = "${colors.background}";
      format-volume-foreground = "${colors.foreground}";
      format-volume-padding = 2;
      format-volume-margin = 0;
      label-muted = "";
      label-volume = "%percentage%%";
      type = "internal/pulseaudio";
    };
  };

  wlan = {
    "module/wlan" = {
      interface = custom.polybar.wifi;
      type = "internal/network";
      accumulate-stats = "true";
      format-connected = "<label-connected>";
      format-connected-background = "${colors.background}";
      format-connected-foreground = "${colors.foreground}";
      format-connected-margin = 0;
      format-connected-overline = "${colors.transparent}";
      format-connected-padding = 2;
      format-connected-underline = "${colors.transparent}";
      format-disconnected = "<label-disconnected>";
      format-disconnected-background = "${colors.background}";
      format-disconnected-foreground = "#909090";
      format-disconnected-margin = 0;
      format-disconnected-overline = "${colors.transparent}";
      format-disconnected-padding = 2;
      format-disconnected-underline = "${colors.transparent}";
      interval = "1.0";
      label-connected = "󰖩 %essid%";
      label-disconnected = "󰖪";
      unknown-as-up = true;
    };
  };

  memory = {
    "module/memory" = {
      format = "<label>";
      format-background = "${colors.background}";
      format-foreground = "${colors.foreground}";
      format-padding = 2;
      format-margin = 0;
      interval = 3;
      label = "RAM %percentage_used%%";
      type = "internal/memory";
    };
  };

  xmonad = {
    "module/xmonad" = {
      type = "custom/script";
      exec = "${pkgs.xmonad-log}/bin/xmonad-log";
      tail = true;
    };
  };

  mic = {
    "module/mic" = let
      mic-volume = pkgs.writeScript "mic-volume" ''
        mic_volume=$(${pkgs.alsa-utils}/bin/amixer get Capture | ${pkgs.gnugrep}/bin/grep -o -E '[0-9]+%' | ${pkgs.coreutils}/bin/head -1)
        mic_status=$(${pkgs.alsa-utils}/bin/amixer get Capture | ${pkgs.gnugrep}/bin/grep -o -E '\[on\]|\[off\]' | ${pkgs.coreutils}/bin/head -1)

        if [ "$mic_status" == "[on]" ]; then
            echo " $mic_volume"
        else
            echo "%{F${colors.urgent}}%{F-}"
        fi
      '';
      toggle-mic = pkgs.writeScript "toggle-mic"
        "${pkgs.alsa-utils}/bin/amixer set Capture toggle";
    in {
      type = "custom/script";
      exec = "${mic-volume}";
      interval = "0.5";
      click-left = "${toggle-mic}";
    };
  };
}
