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

    nixpkgs.config.allowUnfree = true;

    modules = {
      rofi.enable = true;
      firefox.enable = true;
      bash.enable = true;
      direnv.enable = true;
      ssh.enable = true;
    };

    programs = { home-manager.enable = true; };

    services.syncthing.enable = true;

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

      rnix-lsp

      # Fonts
      nerdfonts
    ];
  };
}
