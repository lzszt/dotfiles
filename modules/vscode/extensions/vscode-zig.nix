{ pkgs, ... }:
{
  extension = pkgs.vscode-extensions.ziglang.vscode-zig;
  user-settings.zig.zls = {
    enabled = "on";
    path = "zls";
  };
}
