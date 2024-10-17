{
  custom,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.desktop.polybar;
in
{
  options.modules.desktop.polybar = {
    enable = lib.mkEnableOption "polybar";
    custom-modules.left = lib.mkOption { default = [ ]; };
  };

  config = lib.mkIf cfg.enable {
    services.polybar =
      let
        myPolybar = pkgs.polybar.override {
          alsaSupport = true;
          githubSupport = true;
          pulseSupport = true;
        };
      in
      {
        enable = true;
        package = myPolybar;
        script = ''
          for m in $(polybar --list-monitors | ${pkgs.coreutils}/bin/cut -d":" -f1); do
            WIDTH=$(polybar --list-monitors | ${pkgs.gnugrep}/bin/grep $m | ${pkgs.coreutils}/bin/cut -d":" -f2 | ${pkgs.coreutils}/bin/cut -d"x" -f1)
            if [ $WIDTH -ge 3000 ];
            then
              MODE="bottom"
            else
              MODE="compact"
            fi
            MONITOR=$m polybar -r $MODE &
          done
        '';
        config = import ./config.nix {
          inherit custom pkgs lib;
          custom-modules = cfg.custom-modules;
        };
      };
  };
}
