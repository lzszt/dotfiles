{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.neomutt;
in
{
  options.modules.neomutt.enable = lib.mkEnableOption "neomutt";

  config = lib.mkIf cfg.enable {
    programs.neomutt = {
      enable = true;
      extraConfig = ''
        set sidebar_visible
        set sidebar_format = "%B%?F? [%F]?%* %?N?%N/?%S"
        set mail_check_stats
      '';
    };
  };
}
