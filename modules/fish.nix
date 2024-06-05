{
  custom,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.fish;
in
{
  options.modules.fish = {
    enable = lib.mkEnableOption "fish";
    customAliases = lib.mkOption { default = { }; };
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      shellInit = ''
        bind " " expand-abbr or self-insert
      '';
      shellAbbrs =
        (import ./bash/shell-aliases.nix {
          inherit
            pkgs
            custom
            config
            lib
            ;
        })
        // cfg.customAliases;
    };
  };
}
