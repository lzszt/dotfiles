{
  ...
}:

{
  imports = [
    ../../wm/xmonad.nix
    ../config-base.nix
    ./hardware-configuration.nix
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  nix.settings.max-jobs = 4;

  system.stateVersion = "23.05";
}
