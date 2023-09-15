{ pkgs, custom, config, lib, ... }:

{
  # nix
  nfu = "nix flake update";
  nfl = "nix flake lock";
  nfui = "nix flake lock --update-input";

  # direnv
  dea = "direnv allow";
  ded = "direnv deny";
  der = "direnv reload";

  # git
  gp = "git pull";
  gst = "git status";
  gl = "git log";
  gs = "git stash";
  lgit = "lazygit";

  # misc
  ll = "ls -lisah";

  de = "setxkbmap de";
  us = "setxkbmap us";
} // lib.optionalAttrs (config.home.username == custom.default.user) {
  # nixos
  nrs = "nixos-rebuild switch --use-remote-sudo --flake ~/dotfiles/";
}
