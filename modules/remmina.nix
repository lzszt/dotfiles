{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.remmina;
in
{
  options.modules.remmina = {
    enable = lib.mkEnableOption "remmina";
    matchBlocks = lib.mkOption { default = { }; };
  };

  config = lib.mkIf cfg.enable { home.packages = [ pkgs.remmina ]; };
}
