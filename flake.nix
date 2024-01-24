{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url =
    #   "github:NixOS/nixpkgs/36f57efd82062a44f420d97ddb02b0bf3853ecfe";
    # nixpkgs.url = "git+file:/home/leitz/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfile-secrets.url = "git+ssh://git@github.com/lzszt/dotfile-secrets";
    haskellmode.url = "gitlab:Zwiebeljunge/haskellmode";
    # haskellmode.url = "git+file:/home/leitz/projects/haskellmode";
    cabalAddSrc = {
      url =
        "github:/Bodigrim/cabal-add/eb940d186cc799faebf75e8dcb60f353d340254d";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      overlays = [
        (final: prev: {
          # Shorter than prev.lib.extend (f: p: ...), but I don't know
          # if there's another difference.
          lib = prev.lib // { my = import ./lib { inherit (final) lib; }; };
        })
      ];
      pkgs = import nixpkgs {
        config = {
          allowUnfree = true;

          # Needed as long as obsidian still uses obsolete electron
          permittedInsecurePackages =
            lib.optional (pkgs.obsidian.version == "1.5.3") "electron-25.9.0";
        };
        inherit overlays system;
      };

      inherit (pkgs) lib;
    in {
      formatter.${system} = pkgs.nixfmt;
      nixosConfigurations = let machines = lib.my.readDirNames ./hosts;
      in builtins.foldl' (acc: hostname:
        acc // {
          ${hostname} =
            lib.my.mkNixosSystem { inherit hostname system inputs pkgs; };
        }) { } machines;

      devShells.${system}.default = let pkgs = nixpkgs.legacyPackages.${system};
      in pkgs.mkShell {
        buildInputs = [
          (pkgs.haskellPackages.ghcWithPackages (hp:
            with hp; [
              ormolu
              haskell-language-server
              dbus
              xmonad-contrib
              monad-logger
            ]))
        ];
      };
    };
}
