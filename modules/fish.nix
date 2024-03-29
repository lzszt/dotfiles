{ custom, config, lib, pkgs, ... }:

let cfg = config.modules.fish;
in {
  options.modules.fish = {
    enable = lib.mkEnableOption "fish";
    customAliases = lib.mkOption { default = { }; };
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      plugins = [ ];
      shellAbbrs =
        (import ./bash/shell-aliases.nix { inherit pkgs custom config lib; })
        // cfg.customAliases;
      # interactiveShellInit = ''
      #   set fish_greeting
      #   bind \cp navigate_to_project
      #   bind \cr command_history_search
      #   bind \cv open_file_in_emacs
      # '';
      # shellAliases = {
      #   ls = "exa";
      #   l = "exa -lbF --group-directories-first --icons";
      #   ll = "exa -lbGF --group-directories-first --icons";
      #   la = "exa -labF --group-directories-first --icons";
      #   lla = "exa -labGF --group-directories-first --icons";
      # };
    };

    # Manage functions manually
    # xdg.configFile = {
    #   "fish/functions" = {
    #     source = ./functions;
    #     recursive = true;
    #   };
    # };
  };
}
