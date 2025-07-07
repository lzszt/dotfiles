{
  # editor settings
  editor = {
    minimap.enabled = false;
    tabSize = 2;
    formatOnSave = true;
    folding = false;
    stickyScroll.enabled = false;
  };
  # telemetry settings
  telemetry = {
    telemetryLevel = "off";
    feedback.enabled = false;
  };

  # miscellaneous settings
  workbench = {
    colorThem = "Default Dark+";
    editor.wrapTabs = true;
    startupEditor = "none";
  };

  window = {
    density.editorTabHeight = "compact";
    zoomLevel = 1;
  };

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

  files.insertFinalNewline = true;

  # explorer settings
  explorer = {
    confirmDragAndDrop = false;
    autoReveal = false;
  };

  # default nix settings
  "[nix]" = {
    editor.defaultFormatter = "brettm12345.nixfmt-vscode";
  };
}
