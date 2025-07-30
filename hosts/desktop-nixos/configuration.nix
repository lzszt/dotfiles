{
  pkgs,
  ...
}:

{
  imports = [
    ../../wm/xmonad.nix
    ../config-base.nix
    ./hardware-configuration.nix
  ];

  hardware = {
    graphics = {
      enable = true;
      package = pkgs.mesa;
      enable32Bit = true;
      package32 = pkgs.pkgsi686Linux.mesa;
    };
  };

  virtualisation.docker.enable = true;

  nix.settings.max-jobs = 12;

  system.stateVersion = "22.11";
}
