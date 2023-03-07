{ inputs, custom, config, lib, pkgs, ... }:

let cfg = config.hosts.base;
in {

  imports = [ ./. ];

  config = {

    modules = {
      rofi.enable = true;
      firefox.enable = true;
      bash.enable = true;
      direnv.enable = true;
      ssh.enable = true;
    };

    programs = { home-manager.enable = true; };

    home.packages = with pkgs; [
      keepassxc
      google-chrome
      alacritty
      ripgrep
      lazygit
      htop
      dig
      pavucontrol
    ];
  };
}
