{
  inputs,
  pkgs,
  system,
  ...
}:

{

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
      vscode.enable = true;
    };

    programs = {
      home-manager.enable = true;
    };

    services.syncthing.enable = true;

    xdg = {
      enable = true;
      mime.enable = true;

      desktopEntries = {
        Grayjay = {
          name = "Grayjay";
          genericName = "Web Player";
          exec = "Grayjay %U";
          terminal = false;
          categories = [ "Application" ];
          mimeType = [ "x-scheme-handler/grayjay" ];
        };
      };
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

      (import inputs.nixpkgs-grayjay {
        config.allowUnfree = true;
        inherit system;
      }).grayjay

      thunderbird
      rink

      xdg-utils

      # Fonts
      nerd-fonts.jetbrains-mono
    ];
  };
}
