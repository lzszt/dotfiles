{ pkgs }:

{
  # nixos
  nrs = "sudo nixos-rebuild switch --flake ~/dotfiles/";

  # misc
  ll = "ls -lisah";
}
