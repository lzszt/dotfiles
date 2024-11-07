[
  {
    key = "ctrl+shift+m";
    command = "-workbench.actions.view.problems";
    when = "workbench.panel.markers.view.active";
  }
  {
    key = "ctrl-shift-m";
    command = "workbench.action.toggleMaximizedPanel";
  }
  {
    key = "ctrl+k ctrl+r";
    command = "-workbench.action.keybindingsReference";
  }
  {
    key = "ctrl+k ctrl+r";
    command = "git.revertSelectedRanges";
    when = "editorTextFocus";
  }
  {
    key = "ctrl+k ctrl+r";
    command = "-git.revertSelectedRanges";
    when = "isInDiffEditor && !operationInProgress";
  }
  {
    key = "ctrl+e ctrl+s";
    command = "editor.action.smartSelect.expand";
    when = "editorTextFocus";
  }
  {
    key = "shift+alt+right";
    command = "-editor.action.smartSelect.expand";
    when = "editorTextFocus";
  }
]
