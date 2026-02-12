{
  custom,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.fish;
  fishOnly = alias: { setCursor = true; } // alias;
in
{
  options.modules.fish = {
    enable = lib.mkEnableOption "fish";
    customAliases = lib.mkOption { default = lib.const { }; };
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      shellAbbrs =
        (import ./bash/shell-aliases.nix {
          inherit
            custom
            config
            lib
            fishOnly
            pkgs
            ;
        })
        // cfg.customAliases fishOnly;
    };
  };
}
