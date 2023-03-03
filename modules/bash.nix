{ config, lib, pkgs, ... }:

let cfg = config.modules.bash;
in {
  options.modules.bash = {
    enable = lib.mkEnableOption "bash";
    customAliases = lib.mkOption { default = { }; };
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      historyIgnore = [ "ls" "cd" "exit" ];
      shellAliases = (import ./shell-aliases.nix { inherit pkgs; })
        // cfg.customAliases;
    };
  };
}
