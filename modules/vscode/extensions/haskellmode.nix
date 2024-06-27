{
  pkgs,
  inputs,
  system,
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

  cabal-add = pkgs.haskell.lib.dontCheck (
    pkgs.haskellPackages.callCabal2nix "cabal-add" inputs.cabalAddSrc { }
  );
in
{
  extension = haskellmode;
  user-settings.haskellmode.cabalAddPath = "${cabal-add}/bin/cabal-add";
  default = true;
}
