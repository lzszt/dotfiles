{
  publisher,
  name,
  version,
  sha256,
  default ? false,
  ...
}:
''
  { pkgs, ... }:
  {
    extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
      publisher = \"${publisher}\";
      name = \"${name}\";
      version = \"${version}\";
      sha256 = \"${sha256}\";
    };${if default then ''\ndefault = "true";'' else ""}
  }
''
