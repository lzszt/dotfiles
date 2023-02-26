{ config, pkgs, ... }:

let
  mypolybar = pkgs.polybar.override {
    alsaSupport = true;
    githubSupport = true;
    mpdSupport = true;
    pulseSupport = true;
  };

in {
  services.polybar = {
    enable = true;
    package = mypolybar;
    config = let configFile = ./config.nix; in import configFile pkgs;
    script = ''
      for m in $(polybar --list-monitors | ${pkgs.coreutils}/bin/cut -d":" -f1); do
        MONITOR=$m polybar -r bottom &
      done
    '';
  };
}
