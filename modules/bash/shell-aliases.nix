{
  pkgs,
  custom,
  config,
  lib,
  ...
}:

{
  # nix
  nfu = "nix flake update";
  nfl = "nix flake lock";
  nfc = "nix flake check";
  nfui = "nix flake lock --update-input";
  nd = "nix develop -c fish";
  ns = "nix shell";
  nst = "nix shell this#";
  nr = "nix repl";
  nb = "nix build";
  ncg = "nix-collect-garbage";
  ncgd = "nix-collect-garbage -d";

  # direnv
  dea = "direnv allow";
  ded = "direnv deny";
  der = "direnv reload";

  # git
  gp = "git pull";
  gP = "git push";
  gc = "git clone";
  gst = "git status";
  gl = "git log";
  gs = "git stash";
  gsa = "git stash apply";
  lgit = "lazygit";

  # haskell/cabal

  cb = "cabal build";
  cr = "cabal run";
  cre = "cabal repl";
  ct = "cabal test";
  cc = "cabal clean";
  cbe = "cabal bench";

  # misc
  ll = "ls -lisah";

  de = "setxkbmap de";
  us = "setxkbmap us";
}
// lib.optionalAttrs (config.home.username == custom.default.user) {
  # nixos
  nrs = "nixos-rebuild switch --use-remote-sudo --flake ~/dotfiles/";
  nrb = "nixos-rebuild build --flake ~/dotfiles/";
}
