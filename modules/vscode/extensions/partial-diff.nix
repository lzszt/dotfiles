{ pkgs, ... }:
{
  extension = pkgs.vscode-extensions.ryu1kn.partial-diff;
  user-settings.partialDiff.enableTelemetry = false;
  default = true;
}
