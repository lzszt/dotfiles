{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.modules.vscode;

  userSnippets = {
    global = {
      fixme = {
        prefix = [ "fixme" ];
        body = [ "$LINE_COMMENT FIXME (felix): $0" ];
        description = "Insert a FIXME remark";
      };
    };
    haskell = {
      newtype = {
        prefix = [ "newtype" ];
        body = [ "newtype \${1:Foo} = $1 { \${2:un$1} :: $0}" ];
        description = "Insert a newtype definition";
      };
      record = {
        prefix = [ "record" ];
        body = [
          "data \${1:Foo} = $1 {"
          "	\${1/(.)(.*)/\${1:/downcase}\${2:/camelcase}/}$2 :: $3,"
          "	\${1/(.)(.*)/\${1:/downcase}\${2:/camelcase}/}$4 :: $0"
          "	}"
        ];
        description = "Insert a data record defintion";
      };
      sumtype = {
        prefix = [ "sumtype" ];
        body = [ "data \${1:Foo}" "	= \${2:Bar}" "	| \${0:Baz}" ];
        description = "Insert a data record defintion";
      };
      impl = {
        prefix = [ "impl" ];
        body = [ ''(error "implement ''${0:this}")'' ];
        description = "Insert an implementation as error";
      };
      def = {
        prefix = [ "def" ];
        body = [ "$1 :: $2" ''$1 = ''${0:error "implement $1"}'' ];
        description = "Generate a definition";
      };
    };
  };
in {
  options.modules.vscode = { enable = lib.mkEnableOption "vscode"; };

  config = lib.mkIf cfg.enable {
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

      extensions = with pkgs.vscode-extensions;
        [
          bbenoist.nix
          brettm12345.nixfmt-vscode
          haskell.haskell
          justusadam.language-haskell
          waderyan.gitblame
          donjayamanne.githistory
          arrterian.nix-env-selector
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace
        (import ./extensions.nix).extensions;
    };
    home.activation.vscode-userSnippets = let
      snippetDir = "$HOME/.config/Code/User/snippets";
      generateLanguageSnippetsFile = language: snippets:
        if language == "global" then ''
          SNIPPET_FILE_CONTENT='${builtins.toJSON snippets}'
          echo $SNIPPET_FILE_CONTENT | ${pkgs.jq}/bin/jq . > ${snippetDir}/global.code-snippets
        '' else ''
          SNIPPET_FILE_CONTENT='${builtins.toJSON snippets}'
          echo $SNIPPET_FILE_CONTENT | ${pkgs.jq}/bin/jq . > ${snippetDir}/${language}.json
        '';

      script = lib.concatLines ([ "mkdir -p ${snippetDir}" ]
        ++ lib.mapAttrsToList generateLanguageSnippetsFile userSnippets);
    in lib.hm.dag.entryAfter [ "writeBoundary" ] script;
  };

}
