{
  pkgs,
  lib,
  sshCfg,
  ...
}:
let
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
{
  extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "Kelvin";
    name = "vscode-sshfs";
    version = "1.26.1";
    sha256 = "sha256-WO9vYELNvwmuNeI05sUBE969KAiKYtrJ1fRfdZx3OYU=";
  };
  user-settings.sshfs.configs = sshfsConfigsFromSSHMatchBlocks;
  default = true;
}
