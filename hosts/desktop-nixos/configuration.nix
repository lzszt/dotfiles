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
