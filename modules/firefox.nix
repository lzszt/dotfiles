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
      # You are currently using the legacy default (`".mozilla/firefox"`) because `home.stateVersion` is less than "26.05".
      configPath = ".mozilla/firefox";
      profiles.myprofile.extensions.packages = [
        ffad.adblocker-ultimate
        ffad.cookie-autodelete
        ffad.keepa
        ffad.keepassxc-browser
        ffad.privacy-badger
      ];
    };
  };
}
