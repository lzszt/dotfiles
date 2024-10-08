{ pkgs, ... }:
{
  imports = [ ../minimal/home.nix ];

  accounts = {
    email = {
      accounts = {
        gmail = {
          address = "felix.leitz92@gmail.com";
          userName = "felix.leitz92@gmail.com";
          imap.host = "imap.gmail.com";
          smtp.host = "smtp.gmail.com";
          realName = "Felix Leitz";
          primary = true;
          neomutt.enable = true;
          passwordCommand = "";
          mbsync = {
            enable = true;
            create = "maildir";
          };
        };
      };
    };
  };

  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
  };

  modules = {
    vscode.extensions = {
      vscode-stl-viewer.enable = true;
      preview-tiff.enable = true;
    };

    cloneRepos = {
      enable = true;
      git.repos = {
        dotfile-secrets.url = "git@github.com:lzszt/dotfile-secrets.git";
        projects = {
          it.url = "git@gitlab.com:Zwiebeljunge/it.git";
          haskellmode.url = "git@gitlab.com:Zwiebeljunge/haskellmode.git";
          home-manager.url = "git@github.com:lzszt/home-manager.git";
          nixpkgs.url = "git@github.com:lzszt/nixpkgs.git";
          haskell = {
            config.url = "git@github.com:lzszt/config.git";
            polysemy-utils.url = "git@github.com:lzszt/polysemy-utils.git";
            shortcuts.url = "git@gitlab.com:leitz-projects/shortcuts.git";
            expense-tracker.url = "git@gitlab.com:leitz-projects/expense-tracker.git";
            BILDschirm.url = "git@gitlab.com:leitz-projects/bildschirm.git";
            strava-runner.url = "git@gitlab.com:leitz-projects/strava-runner.git";
            strava-api.url = "git@gitlab.com:Zwiebeljunge/stravaapi.git";
            home-automation.url = "git@gitlab.com:leitz-projects/homeautomation.git";
            cad.url = "git@gitlab.com:leitz-projects/3d.git";
          };
        };
      };
    };
    deej = {
      enable = true;
      config = ''
        # process names are case-insensitive
        # you can use 'master' to indicate the master channel, or a list of process names to create a group
        # you can use 'mic' to control your mic input level (uses the default recording device)
        # you can use 'deej.unmapped' to control all apps that aren't bound to any slider (this ignores master, system, mic and device-targeting sessions)
        # windows only - you can use 'deej.current' to control the currently active app (whether full-screen or not)
        # windows only - you can use a device's full name, i.e. "Speakers (Realtek High Definition Audio)", to bind it. this works for both output and input devices
        # windows only - you can use 'system' to control the "system sounds" volume
        # important: slider indexes start at 0, regardless of which analog pins you're using!
        slider_mapping:
          0: master
          1: firefox
          2: cs2

        # set this to true if you want the controls inverted (i.e. top is 0%, bottom is 100%)
        invert_sliders: false

        # settings for connecting to the arduino board
        com_port: /dev/serial/by-id/usb-Arduino_LLC_Arduino_NANO_33_IoT_A7A4CA055050323339202020FF080B2E-if00
        baud_rate: 9600

        # adjust the amount of signal noise reduction depending on your hardware quality
        # supported values are "low" (excellent hardware), "default" (regular hardware) or "high" (bad, noisy hardware)
        noise_reduction: high
      '';
    };

    vscext-init.enable = true;
  };

  home.packages = with pkgs; [
    docker
    docker-compose
    dbeaver-bin
    jetbrains.datagrip

    prusa-slicer
    openscad-unstable

    teamviewer

    stellarium
  ];

  home.stateVersion = "22.11";
}
