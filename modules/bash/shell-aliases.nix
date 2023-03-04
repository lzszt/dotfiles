{ pkgs }:

{
  # nix
  nfu = "nix flake update";

  # direnv
  dea = "direnv allow";
  ded = "direnv deny";
  der = "direnv reload";

  # git
  gst = "git status";
  gl = "git log";

  # misc
  ll = "ls -lisah";

  de = "setxkbmap de";
  us = "setxkbmap us";
}
