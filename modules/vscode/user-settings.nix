{ sshCfg, lib, ... }:
let
  generateSSHFsConfig = config: {
    name = config.name;
    host = config.host;
    root = config.root;
    username = config.username;
    privateKeyPath = config.privateKeyPath;
  };

  generateSimpleSSHFsConfig = privateKeyPath: host: username:
    generateSSHFsConfig {
      name = host;
      host = host;
      root = if (username == "root") then "/root" else "/home/${username}";
      username = username;
      privateKeyPath = privateKeyPath;
    };

  sshfsConfigsFromSSHMatchBlocks = builtins.map (block:
    generateSimpleSSHFsConfig "$HOME/.ssh/id_ed25519"
    (if (lib.hasAttr "hostname" block) then block.hostname else block.host)
    block.user) (builtins.filter (block: !lib.hasAttr "proxyCommand" block)
      (builtins.attrValues sshCfg.matchBlocks));
in {
  # editor settings
  editor = {
    minimap.enabled = false;
    tabSize = 2;
    formatOnSave = true;
  };
  # telemetry settings
  telemetry.telemetryLevel = "off";

  # miscellaneous settings
  workbench.colorThem = "Default Dark+";
  window.zoomLevel = 1;

  # git settings
  git = {
    confirmSync = false;
    autofetch = true;
    autoStash = true;
  };

  # search settings
  search = {
    collapseResults = "auto";
    useGlobalIgnoreFiles = true;
  };

  # explorer settings
  explorer.confirmDragAndDrop = false;

  # default haskell settings
  haskell = {
    formattingProvider = "ormolu";
    manageHLS = "PATH";
  };

  # default nix settings
  "[nix]" = { editor.defaultFormatter = "brettm12345.nixfmt-vscode"; };
  nix.enableLanguageServer = true;

  # stl viewer settings
  stlViewer = {
    showAxes = true;
    showInfo = true;
    showBoundingBox = true;
    meshMaterialType = "normal";
    viewOffset = 100;
  };

  sshfs.configs = sshfsConfigsFromSSHMatchBlocks;
}
