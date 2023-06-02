{ config, pkgs, lib, custom, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./../../wm/xmonad.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = custom.hostname;
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  hardware.opengl = {
    enable = true;
    package = pkgs.mesa.drivers;
    driSupport32Bit = true;
    package32 = pkgs.pkgsi686Linux.mesa.drivers;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = lib.mapAttrs (user: _: {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
  }) custom.users;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [ nixfmt ];

  # networking.extraHosts = ''
  #   193.186.94.33 dns0.tun0		# vpn-slice-tun0 AUTOCREATED
  #   193.186.94.34 dns1.tun0		# vpn-slice-tun0 AUTOCREATED
  #   193.186.88.7 rdsivo.egv.at rdsivo		# vpn-slice-tun0 AUTOCREATED
  # '';
  # networking.openconnect.interfaces = {
  #   illwerke = {
  #     gateway = "vpn.egv.at";
  #     protocol = "anyconnect";
  #     user = "ext_activegroup2";
  #   };
  # };

  nix = {
    # Enable flakes for the system Nix.
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.trusted-users = [ "root" ] ++ lib.attrNames custom.users;
    settings.max-jobs = 12;
  };

  system.stateVersion = "22.11";
}

