{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.git;
  types = lib.types;
in
{
  options.modules.git.email = lib.mkOption { type = types.str; };
  config.programs.git = {
    enable = true;
    userName = "Felix Leitz";
    userEmail = cfg.email;
    ignores = [
      # Direnv
      ".direnv/"
      ".envrc"

      # VS Code
      ".vscode"

      # nix
      "result"
      "result/*"
    ];
    extraConfig = {
      pull.rebase = "false";
      init.defaultBranch = "main";
    };
  };
}
