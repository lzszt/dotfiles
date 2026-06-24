{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.tuxedo;
in
{
  options.modules.tuxedo = {
    enable = lib.mkEnableOption "polybar";
    path = lib.mkOption {
      type = lib.types.str;
      description = "Path of todo.txt";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.tuxedo ];
    modules.fish.customAliases = fishOnly: {
      tux = "tuxedo ${cfg.path}";
    };
  };
}
