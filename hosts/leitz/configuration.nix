{
  config,
  ...
}:

{
  imports = [
    ../../wm/xmonad.nix
    ../config-base.nix
    ./hardware-configuration.nix
  ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    extraModprobeConfig = "blacklist hid_sensor_hub";
  };

  age = {
    identityPaths = [ "/home/leitz/.ssh/id_ed25519" ];
    secrets.nas-credentials.file = ../../secrets/nas-credentials.age;
  };

  networking.extraHosts = ''
    193.186.94.33 dns0.tun0		# vpn-slice-tun0 AUTOCREATED
    193.186.94.34 dns1.tun0		# vpn-slice-tun0 AUTOCREATED
    193.186.88.7 rdsivo.egv.at rdsivo		# vpn-slice-tun0 AUTOCREATED
  '';

  services = {
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    blueman.enable = true;
  };

  hardware.bluetooth.enable = true;

  virtualisation.docker.enable = true;

  fileSystems."/mnt/nas" = {
    device = "//nas.home.active-group.de/share";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,uid=1000,gid=100";
      in
      [
        "${automount_opts},credentials=${config.age.secrets.nas-credentials.path}"
      ];
  };

  nix.settings.max-jobs = 16;

  system.stateVersion = "23.05";
}
