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
    publisher = "ctf0";
    name = "save-editors-layout";
    version = "1.0.1";
    sha256 = "sha256-8YnAP+njpuuZZkq9YokZP6e4H43jMHPQKHbJSLhbc5w=";
  }
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
]
