{ pkgs, custom, config, lib, ... }:

let
  nix-search = pkgs.writeScript "nix search" ''
    #!/usr/bin/env bash
    SEARCH="https://search.nixos.org/packages?channel=unstable&size=50&sort=relevance&type=packages&query="+$1
    firefox $SEARCH
  '';
  nix-search-option = pkgs.writeScript "nix search script" ''
    #!/usr/bin/env bash
    SEARCH="https://search.nixos.org/options?channel=unstable&size=50&sort=relevance&type=packages&query=+"+$1
    firefox $SEARCH
  '';
in {
  # nix
  nfu = "nix flake update";
  nfl = "nix flake lock";
  nfc = "nix flake check";
  nfui = "nix flake lock --update-input";
  nd = "nix develop --command fish";
  ns = "nix shell";
  nr = "nix repl";
  nb = "nix build";

  # direnv
  dea = "direnv allow";
  ded = "direnv deny";
  der = "direnv reload";

  # git
  gp = "git pull";
  gc = "git clone";
  gst = "git status";
  gl = "git log";
  gs = "git stash";
  lgit = "lazygit";

  # haskell/cabal

  cb = "cabal build";
  cr = "cabal run";
  cre = "cabal repl";
  ct = "cabal test";

  # misc
  ll = "ls -lisah";
  sp = "${nix-search}";
  so = "${nix-search-option}";

  de = "setxkbmap de";
  us = "setxkbmap us";
} // lib.optionalAttrs (config.home.username == custom.default.user) {
  # nixos
  nrs = "nixos-rebuild switch --use-remote-sudo --flake ~/dotfiles/";
}
