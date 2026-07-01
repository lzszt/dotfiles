{
  inputs,
  pkgs,
  ...
}:

{

  imports = [ ./. ];

  config = {
    nix = {
      # Enable flakes for the system Nix.
      extraOptions = ''
        experimental-features = nix-command flakes pipe-operators
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
      bash.enable = true;
      direnv.enable = true;
      firefox.enable = true;
      fish.enable = true;
      lazygit.enable = true;
      rofi.enable = true;
      ssh.enable = true;
      tuxedo.enable = true;
      vscode.enable = true;
    };

    programs = {
      home-manager.enable = true;
    };

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
      btop
      dig
      pavucontrol
      ncdu
      jq
      alsa-utils

      libreoffice

      brave

      thunderbird
      rink

      nix-output-monitor

      xdg-utils

      # Fonts
      nerd-fonts.jetbrains-mono
    ];
  };
}
