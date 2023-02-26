{ config, lib, pkgs, stdenv, ... }: {
  programs.home-manager.enable = true;
  home.stateVersion = "22.11";
  imports = [
    ./programs/xmonad/default.nix
    ./programs/polybar/default.nix
    ./programs/rofi/default.nix
    ./programs/vscode/default.nix
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      userName = "Felix Leitz";
      userEmail = "felix.leitz@active-group.de";
      # delta.enable = true;  whats this???
    };
  };
  home.packages = with pkgs; [
    thunderbird
    keepassxc
    mattermost-desktop
    pavucontrol
    jitsi-meet-electron
    linphone
    lazygit
    ripgrep
    fd
    google-chrome
    firefox

    apache-directory-studio

    ghc
    haskell-language-server
    ormolu

    remmina
    openconnect
    vpn-slice
    teams

    docker
    docker-compose
  ];

}
