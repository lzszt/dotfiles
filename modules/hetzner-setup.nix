{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  cfg = config.modules.hetzner-setup;
  script = pkgs.writeScriptBin "hetzner-setup" ''
    ${
      lib.getExe inputs.hetzner-setup.packages.${pkgs.stdenv.hostPlatform.system}.default
    } --config ${cfg.tokenPath} --context ${cfg.context} $@
  '';
in

{
  options.modules.hetzner-setup = {
    enable = lib.mkEnableOption "hetzner-setup";
    tokenPath = lib.mkOption {
      type = lib.types.str;
      description = "Path to Hetzner API token";
    };
    context = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = "Hetzner API token context";
    };
  };

  config = lib.mkIf config.modules.hetzner-setup.enable {
    home.packages = [
      script
      inputs.hetzner-setup.packages.${pkgs.stdenv.hostPlatform.system}.hetzner-setup-completions
    ];

  };
}
