{
  config,
  lib,
  pkgs,
  custom,
  ...
}:
let
  cfg = config.modules.vscext-init;
  isDefaultUser = config.home.username == custom.default.user;

  marketplace-ext = import ./marketplace-ext.nix;
  vscode-extensions-ext = import ./vscode-extensions-ext.nix;

  init-vscode-extension = pkgs.writeScriptBin "vsext-init" ''
    echo 'Initializing vscode extension'

    read -p "Enter extension name: " EXTNAME
    read -p "Enter extension publisher: " EXTPUBLISHER

    echo 'Trying nix vscode-extensions ...'
    nix build this#vscode-extensions.$EXTPUBLISHER.$EXTNAME 2> /dev/null
    STATUS=$?

    EXTENSION_FILE=~/dotfiles/modules/vscode/extensions/$EXTNAME.nix

    if [ $STATUS -eq 0 ];
    then
      echo "${
        vscode-extensions-ext {
          publisher = "$EXTPUBLISHER";
          name = "$EXTNAME";
        }
      }" > $EXTENSION_FILE
    else
      EXTVERSIONS=$(${pkgs.curl}/bin/curl 'https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery' \
                    -H 'accept: application/json;api-version=7.2-preview.1;excludeUrls=true' \
                    -H 'content-type: application/json' \
                    -s --data-raw "{\"filters\":[{\"criteria\":[{\"filterType\":7,\"value\":\"$EXTPUBLISHER.$EXTNAME\"}]}],\"flags\":2151}" \
                    | ${pkgs.jq}/bin/jq -r '.results | .[0] | .extensions | .[0] | .versions | .[] | .version')

      PS3='Please choose a version: '
      options=($EXTVERSIONS)
      select EXTVERSION in "''${options[@]}"
      do
          SHA256_HASH=$(nix store prefetch-file --json https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$EXTPUBLISHER/vsextensions/$EXTNAME/$EXTVERSION/vspackage \
                          | ${pkgs.jq}/bin/jq -r '.hash')
          echo "${
            marketplace-ext {
              publisher = "$EXTPUBLISHER";
              name = "$EXTNAME";
              version = "$EXTVERSION";
              sha256 = "$SHA256_HASH";
            }
          }" > $EXTENSION_FILE
          break
      done
    fi
  '';

in

{
  options.modules.vscext-init = {
    enable = lib.mkEnableOption "vscext-init";
  };

  config = lib.mkIf (isDefaultUser && cfg.enable) { home.packages = [ init-vscode-extension ]; };
}
