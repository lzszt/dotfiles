{ inputs, ... }:

{
  imports = [
    ./bash
    ./cloneRepos.nix
    ./direnv.nix
    ./firefox.nix
    ./fish.nix
    ./git.nix
    ./mattermost.nix
    ./polybar
    ./rofi
    ./ssh.nix
    ./timetracking
    ./vscext-init
    ./vscode
    ./xmonad

    inputs.nix-starter-kit.nixosModules.timetracking
    inputs.agenix.homeManagerModules.default
  ];
}
