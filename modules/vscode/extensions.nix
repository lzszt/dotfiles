{
  inputs,
  system,
  pkgs,
  lib,
  sshCfg,
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

  generateSSHFsConfig = config: {
    name = config.name;
    host = config.host;
    root = config.root;
    username = config.username;
    privateKeyPath = config.privateKeyPath;
  };

  generateSimpleSSHFsConfig =
    privateKeyPath: host: username:
    generateSSHFsConfig {
      name = host;
      host = host;
      root = if (username == "root") then "/root" else "/home/${username}";
      username = username;
      privateKeyPath = privateKeyPath;
    };

  sshfsConfigsFromSSHMatchBlocks =
    builtins.map
      (
        block:
        generateSimpleSSHFsConfig "$HOME/.ssh/id_ed25519" (
          if (lib.hasAttr "hostname" block) then block.hostname else block.host
        ) block.user
      )
      (
        builtins.filter (block: !lib.hasAttr "proxyCommand" block) (builtins.attrValues sshCfg.matchBlocks)
      );
in
with pkgs.vscode-extensions;
{
  nix = {extension = bbenoist.nix;
  default = true;};

  nixfmt-vscode = {extension = brettm12345.nixfmt-vscode;
  default = true;};

  haskell = {
    extension = haskell.haskell;
    user-settings.haskell = {
      formattingProvider = "ormolu";
      manageHLS = "PATH";
    };
    default = true;
  };

  language-haskell = {extension = justusadam.language-haskell;
  default = true;};

  gitblame = {
    extension = waderyan.gitblame;
    user-settings.gitblame.ignoreWhitespace = true;
    default = true;
  };

  githistory = {extension = donjayamanne.githistory;
  default = true;};

  haskellmode = {
    extension = haskellmode;
    user-settings.haskellmode.cabalAddPath = "${cabal-add}/bin/cabal-add";
    default = true;
  };

  direnv = {extension = mkhl.direnv;
  default = true;};

  pdf = {extension = tomoki1207.pdf;
  default = true;};

  vscode-sshfs = {
    extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
      publisher = "Kelvin";
      name = "vscode-sshfs";
      version = "1.26.1";
      sha256 = "sha256-WO9vYELNvwmuNeI05sUBE969KAiKYtrJ1fRfdZx3OYU=";
    };
    user-settings.sshfs.configs = sshfsConfigsFromSSHMatchBlocks;
    default = true;
  };

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
}
