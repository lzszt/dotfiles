{ config, lib, ... }:
let
  cfg = config.modules.nixos-hetzner-init;
in
{
  options.modules.nixos-hetzner-init = {
    enable = lib.mkEnableOption "nixos-hetzner-init";
  };

  config = lib.mkIf cfg.enable {

  };
}
