{
  publisher,
  name,
  default ? false,
  ...
}:
''
  { pkgs, ... }:
  {
    extension = pkgs.vscode-extensions.${publisher}.${name};${
      if default then ''\ndefault = "true";'' else ""
    }
  }
''
