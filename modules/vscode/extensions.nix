{ inputs, system, pkgs, ... }:
let
  vsixToZip = input: filename:
    pkgs.stdenv.mkDerivation {
      name = "vsix-to-zip";
      src = input;
      buildPhase = pkgs.writeScript "vsix-to-zip" ''
        mkdir result
        mv ${filename}.vsix result/${filename}.zip
        mv result $out
      '';
    };

  haskellmode = let
    haskellmodeInput = inputs.haskellmode.packages.${system};
    haskellmode-version = haskellmodeInput.haskellmode-version;

    extensionFilename = "haskellmode-${haskellmode-version}";

  in pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "lzszt";
      name = "haskell-mode";
      version = haskellmode-version;
    };
    vsix = "${
        vsixToZip haskellmodeInput.haskellmode extensionFilename
      }/${extensionFilename}.zip";
  };
in with pkgs.vscode-extensions;
[
  bbenoist.nix
  brettm12345.nixfmt-vscode
  haskell.haskell
  justusadam.language-haskell
  waderyan.gitblame
  donjayamanne.githistory
  arrterian.nix-env-selector
  haskellmode
] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  {
    publisher = "mtsmfm";
    name = "vscode-stl-viewer";
    version = "0.3.0";
    sha256 = "sha256-1xQl+5PMAsSjf9y25/G63Z5YYj8mQMPOuDSVY4YBukc=";
  }
  {
    publisher = "nwolverson";
    name = "language-purescript";
    version = "0.2.8";
    sha256 = "sha256-2uOwCHvnlQQM8s8n7dtvIaMgpW8ROeoUraM02rncH9o=";
  }
  {
    publisher = "nwolverson";
    name = "ide-purescript";
    version = "0.26.1";
    sha256 = "sha256-ccTuoDSZKf1WsTRX2TxXeHy4eRuOXsAc7rvNZ2b56MU=";
  }
]

