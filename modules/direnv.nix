{ config, lib, ... }:
let
  cfg = config.modules.direnv;
in
{
  options.modules.direnv.enable = lib.mkEnableOption "direnv";
  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
