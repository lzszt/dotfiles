{ config, lib, ... }:
let
  cfg = config.modules.git;
  types = lib.types;
in
{
  options.modules.git.email = lib.mkOption { type = types.str; };
  config.programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Felix Leitz";
        email = cfg.email;
      };
      pull.rebase = "false";
      init.defaultBranch = "main";
    };
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
  };
}
