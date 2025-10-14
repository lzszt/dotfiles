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
      rofi.enable = true;
      firefox.enable = true;
      bash.enable = true;
      direnv.enable = true;
      ssh.enable = true;
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
      lazygit
      btop
      dig
      pavucontrol
      ncdu
      jq
      alsa-utils

      brave

      thunderbird
      rink

      xdg-utils

      # Fonts
      nerd-fonts.jetbrains-mono
    ];
  };
}
