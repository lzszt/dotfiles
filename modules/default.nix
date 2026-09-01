{ inputs, ... }:

{
  imports = [
    ./bash
    ./cloneRepos.nix
    ./direnv.nix
    ./firefox.nix
    ./fish.nix
    ./git.nix
    ./lazygit.nix
    ./mattermost.nix
    ./nixos-hetzner-init
    ./polybar
    ./rofi
    ./ssh.nix
    ./timetracking
    ./tuxedo.nix
    ./vscext-init
    ./vscode
    ./xmonad

    inputs.agenix.homeManagerModules.default
  ];
}
