{ config, lib, pkgs, stdenv, ... }: {
  programs.home-manager.enable = true;
  home.stateVersion = "22.11";
  imports = [ ./programs ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    firefox = {
      enable = true;
      profiles.myprofile.extensions = [ ];
    };

    };

  modules = { git.email = "felix.leitz92@gmail.com"; };

  home.packages = with pkgs; [
    thunderbird
    keepassxc
    signal-desktop
    discord
    ghc
    haskell-language-server
    ormolu
    pavucontrol

    docker
    docker-compose

    google-chrome

    steam

    prusa-slicer

    alacritty

    rink

    ripgrep
    lazygit

    # Fonts
    font-awesome_5
    nerdfonts
  ];

  # home.activation = {
  #   cloneRepos = let
  #     cloneSingleRepo = dir: url: ''
  #       mkdir -p $HOME/${dir}
  #       cd ${dir}
  #       $DRY_RUN_CMD ${pkgs.git}/bin/git clone ${url}
  #     '';
  #     script =
  #       cloneSingleRepo "foobar" "https://github.com/neshtea/dotfiles.git";
  #   in lib.hm.dag.entryAfter [ "writeBoundary" ] script;
  # };

  services = {
    dropbox = {
      enable = true;
      path = "${config.home.homeDirectory}/Dropbox";
    };
  };
}
