{
  config,
  lib,
  custom,
  ...
}:
let
  cfg = config.modules.timetracking;
in

{
  options.modules.timetracking = {
    enable = lib.mkEnableOption "timetracking";
  };

  config = lib.mkIf cfg.enable { home.packages = [ custom.secrets.ag.timetracking ]; };
}
