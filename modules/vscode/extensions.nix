{
  inputs,
  system,
  pkgs,
  ...
}:
let
  # This is needed because buildVscodeMarketplaceExtension
  # normally downloads the .vsix file as .zip.
  vsixToZip =
    input: filename:
    pkgs.stdenv.mkDerivation {
      name = "vsix-to-zip";
      src = input;
      buildPhase = pkgs.writeScript "vsix-to-zip" ''
        mkdir result
        mv ${filename}.vsix result/${filename}.zip
        mv result $out
      '';
    };

  haskellmode =
    let
      haskellmodeInput = inputs.haskellmode.packages.${system};
      haskellmode-version = haskellmodeInput.haskellmode-version;

      extensionFilename = "haskellmode-${haskellmode-version}";
    in
    pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        publisher = "lzszt";
        name = "haskell-mode";
        version = haskellmode-version;
      };
      vsix = "${vsixToZip haskellmodeInput.haskellmode extensionFilename}/${extensionFilename}.zip";
    };
in
with pkgs.vscode-extensions;
{
  defaultExtensions =
    [
      bbenoist.nix
      brettm12345.nixfmt-vscode
      haskell.haskell
      justusadam.language-haskell
      waderyan.gitblame
      donjayamanne.githistory
      haskellmode
      mkhl.direnv
      tomoki1207.pdf
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        publisher = "Kelvin";
        name = "vscode-sshfs";
        version = "1.26.1";
        sha256 = "sha256-WO9vYELNvwmuNeI05sUBE969KAiKYtrJ1fRfdZx3OYU=";
      }
      # {
      #   publisher = "romanpeshkov";
      #   name = "vscode-text-tables";
      #   version = "0.1.5";
      #   sha256 = "sha256-xUj8kA824wM99PJzoUtJAAlkiJG0IipwKGrl+ck8TJQ=";
      # }
    ];

  customExtensions = {
    vscode-stl-viewer = {
      extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
        publisher = "mtsmfm";
        name = "vscode-stl-viewer";
        version = "0.3.0";
        sha256 = "sha256-1xQl+5PMAsSjf9y25/G63Z5YYj8mQMPOuDSVY4YBukc=";
      };
      user-settings.stlViewer = {
        showAxes = true;
        showInfo = true;
        showBoundingBox = true;
        meshMaterialType = "normal";
        viewOffset = 100;
      };
    };
  };
}
