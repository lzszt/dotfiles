{ pkgs, custom, config, lib, ... }:

{
  # nix
  nfu = "nix flake update";
  nfui = "nix flake lock --update-input";

  # direnv
  dea = "direnv allow";
  ded = "direnv deny";
  der = "direnv reload";

  # git
  gp = "git pull";
  gst = "git status";
  gl = "git log";
  lgit = "lazygit";

  # misc
  ll = "ls -lisah";

  de = "setxkbmap de";
  us = "setxkbmap us";
} // lib.optionalAttrs (config.home.username == custom.default.user) {
  # nixos
  nrs = "sudo nixos-rebuild switch --flake ~/dotfiles/";
}
