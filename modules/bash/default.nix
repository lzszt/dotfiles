{ config, lib, pkgs, ... }:

let cfg = config.modules.bash;
in {
  options.modules.bash = {
    enable = lib.mkEnableOption "bash";
    customAliases = lib.mkOption { default = { }; };
    haskellProjectBootstrap.enable = lib.mkOption { default = false; };
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;

      initExtra = ''
        PS1=$'\[\033[01;32m\]\u \[\033[00m\]\[\033[01;36m\]\w \[\033[00m\]$(${
          ./nix.bash
        })\[\033[01;36m\]\U276F\[\033[00m\] '
      '';

      historyIgnore = [ "ls" "cd" "exit" ];

      shellAliases = (import ./shell-aliases.nix { inherit pkgs; })
        // cfg.customAliases // (if cfg.haskellProjectBootstrap.enable then {
          hpb = import ./haskell-project-bootstrap.nix { inherit pkgs; };
        } else
          { });
    };
  };
}
