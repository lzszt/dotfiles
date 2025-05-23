{
  pkgs,
  lib,
  custom,
  self,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../wm/xmonad.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    tmp.cleanOnBoot = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = custom.hostname;
    networkmanager.enable = true;
    firewall.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  hardware = {
    graphics = {
      enable = true;
      package = pkgs.mesa;
      enable32Bit = true;
      package32 = pkgs.pkgsi686Linux.mesa;
    };
  };

  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = lib.mapAttrs (user: _: {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "dialout"
    ];
    shell = pkgs.fish;
  }) custom.users;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [ nixfmt-rfc-style ];

  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      trusted-users = [ "root" ] ++ lib.attrNames custom.users;
      max-jobs = 12;
      trusted-public-keys = [ "turing:2Om1SNna/w1LfgW+hIy/A7LAQOLLewfQTSHZ5FL8j/k=" ];
    };
  };

  system = {
    stateVersion = "22.11";

    configurationRevision = self.rev or "dirty";
  };
}
