{ config, pkgs, lib, custom, ... }:

{
  imports = [ ./hardware-configuration.nix ../../wm/xmonad.nix ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    tmp.cleanOnBoot = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = custom.hostname;
    networkmanager.enable = true;
    firewall.enable = true;
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
    settings = {
      trusted-users = [ "root" ] ++ lib.attrNames custom.users;
      max-jobs = 12;
      substituters = [ "http://turing" ];
      trusted-public-keys =
        [ "turing:2Om1SNna/w1LfgW+hIy/A7LAQOLLewfQTSHZ5FL8j/k=" ];
    };
  };

  system.stateVersion = "23.05";
}

