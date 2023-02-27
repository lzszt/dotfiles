{ pkgs }:

{
  # nixos
  nrs = "sudo nixos-rebuild switch --flake ~/dotfiles/";

  # direnv
  dea = "direnv allow";
  ded = "direnv deny";
  der = "direnv reload";

  # misc
  ll = "ls -lisah";
}
