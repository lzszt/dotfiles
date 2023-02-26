{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    userSettings = {
      # editor settings
      "editor.minimap.enabled" = false;
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
      # telemetry settings
      "telemetry.enableTelemetry" = false;
      "telemetry.enableCrashReporter" = false;
      # miscellaneous settings
      "workbench.colorThem" = "Default Dark+";
      "window.zoomLevel" = 1;
      # git settings
      "git.confirmSync" = false;
      "git.autofetch" = true;

      # default haskell settings
      "haskell.formattingProvider" = "ormolu";
    };

    keybindings = [
      # {
      #   key = "ctrl+j";
      #   command = "workbench.action.focusActiveEditorGroup";
      #   when = "!terminalFocus";
      # }
    ];

    extensions = with pkgs.vscode-extensions;
      [
        bbenoist.nix
        brettm12345.nixfmt-vscode
        haskell.haskell
        justusadam.language-haskell
        waderyan.gitblame
        donjayamanne.githistory
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace
      (import ./extensions.nix).extensions;
  };
}
