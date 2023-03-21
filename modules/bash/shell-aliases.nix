{ pkgs }:

{
  # nix
  nfu = "nix flake update";
  nfui = "nix flake lock --update-input";

  # direnv
  dea = "direnv allow";
  ded = "direnv deny";
  der = "direnv reload";

  # git
  gst = "git status";
  gl = "git log";
  lgit = "lazygit";

  # misc
  ll = "ls -lisah";

  de = "setxkbmap de";
  us = "setxkbmap us";
}
