{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.firefox;
  ffad = pkgs.nur.repos.rycee.firefox-addons;
in
{
  options.modules.firefox.enable = lib.mkEnableOption "firefox";
  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.myprofile.extensions = [
        ffad.adblocker-ultimate
        ffad.keepa
        ffad.keepassxc-browser
        ffad.privacy-badger
      ];
    };
  };
}
