{ config, pkgs, lib, custom, ... }:

{
  imports = [ ./hardware-configuration.nix ../../wm/xmonad.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
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
    extraGroups =
      [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  }) custom.users;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [ nixfmt ];

  nix = {
    settings = {
      trusted-users = [ "root" ] ++ lib.attrNames custom.users;
      max-jobs = 12;
    };
  };

  system.stateVersion = "22.11";
}

