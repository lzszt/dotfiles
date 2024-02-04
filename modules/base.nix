{ inputs, custom, config, lib, pkgs, ... }:

let cfg = config.hosts.base;

in {

  imports = [ ./. ];

  config = {
    nix = {
      # Enable flakes for the system Nix.
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      registry = {
        this.flake = inputs.nixpkgs;
        n.to = {
          id = "nixpkgs";
          type = "indirect";
        };
      };
    };

    modules = {
      rofi.enable = true;
      firefox.enable = true;
      bash.enable = true;
      direnv.enable = true;
      ssh.enable = true;
    };

    programs = { home-manager.enable = true; };

    services.syncthing.enable = true;

    xdg = {
      enable = true;
      mime.enable = true;
    };

    home.packages = with pkgs; [
      keepassxc
      google-chrome
      alacritty
      ripgrep
      lazygit
      htop
      dig
      pavucontrol
      ncdu
      jq

      obsidian

      thunderbird
      rink

      rnix-lsp

      xdg-utils

      # Fonts
      nerdfonts
    ];
  };
}
