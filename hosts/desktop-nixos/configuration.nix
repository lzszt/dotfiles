{
  config,
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

  age = {
    identityPaths = [ "/home/leitz/.ssh/id_ed25519" ];
    secrets.hetzner-storage-box-credentials.file = ../../secrets/hetzner-storage-box-credentials.age;
  };

  # shairport-sync announces itself to iPhones and Macs through Avahi over D-Bus
  services.avahi = {
    enable = true;
    settings.publish = {
      enable = true;
      # allows programs to publish services over D-Bus
      disable-user-service-publishing = false;
      publish-addresses = true;
    };
  };

  # Classic AirPlay (AirPlay 1) ports, from the shairport-sync README
  networking.firewall = {
    allowedTCPPorts = [ 5000 ]; # RTSP control connection
    allowedUDPPortRanges = [
      {
        from = 6000;
        to = 6009;
      } # audio, control and timing streams
    ];
  };

  # The receiver runs in your session, next to PipeWire
  systemd.user.services.shairport-sync = {
    description = "AirPlay audio receiver";
    wantedBy = [ "default.target" ]; # starts with any session of yours
    after = [ "pipewire.service" ]; # PipeWire must be running first
    wants = [ "pipewire.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.shairport-sync}/bin/shairport-sync -o pipewire -a 'Desktop NixOS'";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  environment.systemPackages = with pkgs; [ cifs-utils ];
  fileSystems."/mnt/storagebox" = {
    device = "//u444360.your-storagebox.de/backup";
    fsType = "cifs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "credentials=${config.age.secrets.hetzner-storage-box-credentials.path}"
      "uid=1000"
      "gid=100"
    ];
  };

  virtualisation.docker.enable = true;

  nix.settings.max-jobs = 12;

  system.stateVersion = "22.11";
}
