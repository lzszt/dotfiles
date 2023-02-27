{ config, lib, pkgs, ... }:
let cfg = config.modules.direnv;
in {
  options.modules.direnv.enable = lib.mkEnableOption "direnv";
  config.programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
}

