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

      initExtra = ''
        precmd () {
            local nix_tag
            if [[ x"$IN_NIX_SHELL" == "x" ]]; then
                nix_tag=""
            else
                nix_tag="[nix]"
            fi

            PR_NIX_SHELL=%F{240}$nix_tag%f
        }

        PS1=$'\[\033[01;32m\]\u \[\033[00m\]\[\033[01;36m\]\w $(${
          ./nix.bash
        })\U2b9e\[\033[00m\] '
      '';

      historyIgnore = [ "ls" "cd" "exit" ];

      shellAliases = (import ./shell-aliases.nix { inherit pkgs; })
        // cfg.customAliases;
    };
  };
}
