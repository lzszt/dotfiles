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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = lib.mapAttrs (user: _: {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  }) custom.users;

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
    stateVersion = "23.05";

    configurationRevision = self.rev or "dirty";
  };
}
