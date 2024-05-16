{ config, pkgs, lib, custom, ... }:

{
  imports = [ ./hardware-configuration.nix ../../wm/xmonad.nix ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    tmp.cleanOnBoot = true;
    extraModprobeConfig = "blacklist hid_sensor_hub";
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = custom.hostname;
    networkmanager.enable = true;
    firewall.enable = true;
    extraHosts = ''
      193.186.94.33 dns0.tun0		# vpn-slice-tun0 AUTOCREATED
      193.186.94.34 dns1.tun0		# vpn-slice-tun0 AUTOCREATED
      193.186.88.7 rdsivo.egv.at rdsivo		# vpn-slice-tun0 AUTOCREATED
    '';
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

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
      max-jobs = 16;
      trusted-public-keys =
        [ "turing:2Om1SNna/w1LfgW+hIy/A7LAQOLLewfQTSHZ5FL8j/k=" ];
    };
  };

  system.stateVersion = "23.05";
}

