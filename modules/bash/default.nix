{
  config,
  lib,
  custom,
  pkgs,
  ...
}:

let
  cfg = config.modules.bash;
  fishOnly = lib.const null;
in
{
  options.modules.bash = {
    enable = lib.mkEnableOption "bash";
    customAliases = lib.mkOption { default = lib.const { }; };
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;

      initExtra = ''
        PS1=$'\[\033[01;32m\]\u \[\033[00m\]\[\033[01;36m\]\w \[\033[00m\]$(${./nix.bash})\[\033[01;36m\]\U276F\[\033[00m\] '
      '';

      historyIgnore = [
        "ls"
        "cd"
        "exit"
      ];
      historyControl = [
        "erasedups"
        "ignoredups"
        "ignorespace"
      ];

      shellAliases = lib.attrsets.filterAttrs (_: abbr: !builtins.isNull abbr) (
        (import ./shell-aliases.nix {
          inherit
            custom
            config
            lib
            fishOnly
            pkgs
            ;

        })
        // cfg.customAliases fishOnly
      );
    };
  };
}
