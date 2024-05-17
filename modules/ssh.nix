{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.ssh;
in
{
  options.modules.ssh = {
    enable = lib.mkEnableOption "ssh";
    matchBlocks = lib.mkOption { default = { }; };
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      compression = true;

      matchBlocks = cfg.matchBlocks;
    };
  };
}
