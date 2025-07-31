{
  ...
}:

{
  imports = [
    ../../wm/xmonad.nix
    ../config-base.nix
    ./hardware-configuration.nix
  ];

  boot.extraModprobeConfig = "blacklist hid_sensor_hub";

  networking.extraHosts = ''
    193.186.94.33 dns0.tun0		# vpn-slice-tun0 AUTOCREATED
    193.186.94.34 dns1.tun0		# vpn-slice-tun0 AUTOCREATED
    193.186.88.7 rdsivo.egv.at rdsivo		# vpn-slice-tun0 AUTOCREATED
  '';

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  virtualisation.docker.enable = true;

  fileSystems = {
    "/mnt/freenas" = {
      device = "freenas.home.active-group.de:/mnt/share/storage";
      fsType = "nfs";
    };
  };

  nix.settings.max-jobs = 16;

  system.stateVersion = "23.05";
}
