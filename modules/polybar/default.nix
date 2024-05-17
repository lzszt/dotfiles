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
            MONITOR=$m polybar -r bottom &
          done
        '';
        config = import ./config.nix {
          inherit custom pkgs lib;
          custom-modules = cfg.custom-modules;
        };
      };
  };
}
