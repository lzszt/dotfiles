{ config, pkgs, lib, custom, ... }:

{
  imports = [ ./hardware-configuration.nix ../../wm/xmonad.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "work-test";
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = lib.mapAttrs (user: _: {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
  }) custom.users;

  environment.systemPackages = with pkgs; [ nixfmt ];

  nix = {
    # Enable flakes for the system Nix.
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.trusted-users = [ "root" ] ++ lib.attrNames custom.users;
    settings.max-jobs = 12;
  };

  system.stateVersion = "23.05";
}

