{
  pkgs,
  custom,
  config,
  lib,
  fishOnly,
  ...
}:

{
  # nix
  nfu = "nix flake update";
  nfl = "nix flake lock";
  nfc = "nix flake check";
  nd = "nix develop -c fish";
  ns = "nix shell";
  nst = fishOnly {
    expansion = "nix shell this#%";
  };
  nrt = fishOnly {
    expansion = "nix run this#%";
  };
  nrd = fishOnly {
    expansion = "nix run .#%";
  };
  nr = "nix repl";
  nb = "nix build";
  nbl = "nix build -L";
  ncg = "nix-collect-garbage";
  ncgd = "nix-collect-garbage -d";

  nsp = fishOnly {
    expansion = "open firefox 'https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=%'";
  };
  nso = fishOnly {
    expansion = "open firefox 'https://search.nixos.org/options?channel=unstable&size=50&sort=relevance&type=packages&query=%'";
  };

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
  glo = "git log --oneline";
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
  nrs = "nixos-rebuild switch --sudo --flake ~/dotfiles/";
  nrb = "nixos-rebuild build --flake ~/dotfiles/";
  nlg = "nixos-rebuild list-generations | head -n 10";
}
