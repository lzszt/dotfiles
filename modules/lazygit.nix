{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.lazygit;
in
{
  options.modules.lazygit = {
    enable = lib.mkEnableOption "lazygit";
    config = lib.mkOption {
      type = lib.types.attrs;
      default = {
        keybinding.commits = {
          moveDownCommit = [
            "<ctrl+alt+shift+meta+down>"
            "<ctrl+alt+shift+meta+j>"
          ];
          moveUpCommit = [
            "<ctrl+alt+shift+meta+up>"
            "<ctrl+alt+shift+meta+k>"
          ];
        };
      };
      description = "Lazygit config";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.lazygit ];
    xdg.configFile."lazygit/config.yml".text = lib.generators.toYAML { } cfg.config;
  };
}
