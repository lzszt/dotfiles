{
  pkgs,
  inputs,
  system,
  ...
}:
let
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
      vsix = "${haskellmodeInput.haskellmode}/${extensionFilename}.vsix";
    };
in
{
  extension = haskellmode;
  default = true;
}
