{
  config,
  pkgs,
  lib,
  custom,
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
    opengl = {
      enable = true;
      package = pkgs.mesa.drivers;
      driSupport32Bit = true;
      package32 = pkgs.pkgsi686Linux.mesa.drivers;
    };
    pulseaudio.enable = true;
  };

  # Enable sound.
  sound.enable = true;

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
    settings = {
      trusted-users = [ "root" ] ++ lib.attrNames custom.users;
      max-jobs = 12;
      substituters = [ "http://turing" ];
      trusted-public-keys = [ "turing:2Om1SNna/w1LfgW+hIy/A7LAQOLLewfQTSHZ5FL8j/k=" ];
    };
  };

  system.stateVersion = "22.11";
}
