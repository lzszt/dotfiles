{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.modules.deej;
  deej = pkgs.buildGoModule rec {
    pname = "deej";
    version = "latest";

    src = inputs.deejSrc;

    vendorHash = "sha256-1gjFPD7YV2MTp+kyC+hsj+NThmYG3hlt6AlOzXmEKyA=";

    ldflags = [
      "-X main.versionTag=${version}"
      "-X main.gitCommit=${inputs.deejSrc.shortRev}"
      "-X main.buildType=nix-release"
      "-s"
      "-w"
    ];

    nativeBuildInputs = with pkgs; [ pkg-config ];
    buildInputs = with pkgs; [ libappindicator-gtk3 webkitgtk ];

    meta = with pkgs.lib; {
      description = "";

      homepage = "https://github.com/omriharel/deej";
      maintainers = with maintainers; [ ];
      license = licenses.mit;

      mainProgram = "cmd";
    };
  };

  deejConfig = pkgs.writeText "config.yaml" cfg.config;

  deej-runner = pkgs.stdenv.mkDerivation {
    name = "deej-runner";
    dontUnpack = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      cp ${deejConfig} $out/config.yaml
      cp ${deej}/bin/cmd $out/deej
    '';
  };

in {
  options.modules.deej = {
    enable = lib.mkEnableOption "deej";
    config = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    systemd.user.services.deej = {
      Unit = {
        Description =
          "Run deej to control audio levels via an arduino based controller.";
      };
      Install = { WantedBy = [ "default.target" ]; };
      Service = {
        ExecStart = "${deej-runner}/deej";
        WorkingDirectory = deej-runner;
      };
    };
  };
}

