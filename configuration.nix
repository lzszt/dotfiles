# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "foobar";
    networkmanager.enable = true;
  };
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      windowManager = {
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          config = ''
          import XMonad

          main = xmonad def
            	{ modMask = mod4Mask
            	, terminal = "kitty"
            	}
          '';
        };
      };
    };
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.leitz = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      # gaming
      steam

      # development
      google-chrome
      direnv
      nix-direnv
      docker
      docker-compose
      jetbrains.datagrip
      postman

      # work
      jitsi-meet-electron
      mattermost-desktop

      # others
      dropbox
      signal-desktop
      keepass
      texstudio
      discord
      thunderbird
      kitty
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nixfmt
    firefox
    kupfer
    git
    dmenu
    pavucontrol
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions;
        [
          # nix extensions
          bbenoist.nix
          brettm12345.nixfmt-vscode
          arrterian.nix-env-selector

          # haskell extensions
          haskell.haskell
          justusadam.language-haskell

          zxh404.vscode-proto3

          # scala extensions
          scala-lang.scala
          scalameta.metals

          # clojure/clojurescript extensions
          betterthantomorrow.calva

          # dhall extensions
          dhall.dhall-lang

          # git extensions
          donjayamanne.githistory
        ] ++ vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "gitblame";
            publisher = "waderyan";
            version = "8.2.2";
            sha256 = "sha256-HxUzVutQI/wR/ni1BT0xajuv0pcoOGyzrZXzm29dyrA=";
          }
          {
            name = "haskell-spotlight";
            publisher = "visortelle";
            version = "0.0.3";
            sha256 = "sha256-pHrGjAwb5gWxzCtsUMU6+zdQTI8aMxiwtQi4fc9JH9g=";
          }
          {
            name = "haskell-linter";
            publisher = "hoovercj";
            version = "0.0.6";
            sha256 = "sha256-MjgqR547GC0tMnBJDMsiB60hJE9iqhKhzP6GLhcLZzk=";
          }
          {
            name = "makefile-tools";
            publisher = "ms-vscode";
            version = "0.5.0";
            sha256 = "sha256-oBYABz6qdV9g7WdHycL1LrEaYG5be3e4hlo4ILhX4KI=";
          }
          {
            name = "org-code";
            publisher = "SeungukShin";
            version = "0.0.1";
            sha256 = "sha256-PXhbwEjv6Ce0E4uhqYkrq5u+18c2B8U6wLoagT+kje4=";
          }
          {
            name = "prettify-json";
            publisher = "mohsen1";
            version = "0.0.3";
            sha256 = "sha256-lvds+lFDzt1s6RikhrnAKJipRHU+Dk85ZO49d1sA8uo=";
          }

        ];
    })
  ];

  nix = {
    # Enable flakes for the system Nix.
    extraOptions = ''
      	experimental-features = nix-command flakes
        keep-outputs = true
        keep-derivations = true
    '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

