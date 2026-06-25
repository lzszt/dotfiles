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
    customAliases = lib.mkOption {
      type = lib.mkOptionType {
        name = "Alias function";
        merge =
          loc: defs: fishOnly:
          defs |> builtins.map (x: x.value fishOnly) |> lib.foldl' lib.recursiveUpdate { };
      };
      default = lib.const { };
    };
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
