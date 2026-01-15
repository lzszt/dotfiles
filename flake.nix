{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfile-secrets.url = "git+ssh://git@github.com/lzszt/dotfile-secrets";
    haskellmode.url = "gitlab:Zwiebeljunge/haskellmode";
    # haskellmode.url = "git+file:///home/leitz/projects/haskellmode";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    nix-starter-kit.url = "github:active-group/nix-starter-kit";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";
      overlays = [
        (final: prev: {
          # Shorter than prev.lib.extend (f: p: ...), but I don't know
          # if there's another difference.
          lib = prev.lib // {
            my = import ./lib/nixos.nix { inherit (final) lib; };
          };
        })
      ];
      pkgs = import nixpkgs { inherit overlays system; };

      inherit (pkgs) lib;
    in
    {
      formatter.${system} = pkgs.nixfmt;
      nixosConfigurations =
        let
          machines = lib.my.readDirNames ./hosts;
        in
        builtins.foldl' (
          acc: hostname: acc // { ${hostname} = lib.my.mkNixosSystem { inherit hostname inputs self; }; }
        ) { } machines;

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          (pkgs.haskellPackages.ghcWithPackages (
            hp: with hp; [
              ormolu
              haskell-language-server
              dbus
              xmonad-contrib
              monad-logger
            ]
          ))
        ];
      };
    };
}
