{ config, lib, pkgs, stdenv, ... }: {
  programs.home-manager.enable = true;
  home.stateVersion = "22.11";
  imports = [ ./programs ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  modules = {
    git.email = "felix.leitz@active-group.de";
    desktop.xmonad.enable = true;
    desktop.polybar.enable = true;
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
