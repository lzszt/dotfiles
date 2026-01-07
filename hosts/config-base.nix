{
  self,
  pkgs,
  lib,
  custom,
  ...
}:
{
  boot = {
    tmp.cleanOnBoot = true;
    # Use the systemd-boot EFI boot loader.
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

  programs.fish.enable = true;

  environment.systemPackages = [ pkgs.nixfmt ];

  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      trusted-users = [ "root" ] ++ lib.attrNames custom.users;
      trusted-public-keys = [ "turing:2Om1SNna/w1LfgW+hIy/A7LAQOLLewfQTSHZ5FL8j/k=" ];
    };
  };

  system.configurationRevision = self.rev or "dirty";
}
