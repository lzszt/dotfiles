{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.modules.vscode;

  userSnippets = {
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
  globalSnippets = {
    fixme = {
      prefix = [ "fixme" ];
      body = [ "$LINE_COMMENT FIXME (felix): $0" ];
      description = "Insert a FIXME remark";
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
    home.activation.vscode-snippets = let
      snippetDir = "$HOME/.config/Code/User/snippets";

      generateSnippetFile = filename: snippets:
        "$DRY_RUN_CMD echo '${
          builtins.toJSON snippets
        }' | ${pkgs.jq}/bin/jq . > ${snippetDir}/${filename}";

      generateLanguageSnippetsFile = language:
        generateSnippetFile "${language}.json";

      generateUserSnippetFiles = lib.concatLines
        (lib.mapAttrsToList generateLanguageSnippetsFile userSnippets);

      generateGlobalSnippets = generateSnippetFile "global.code-snippets";

      generateGlobalSnippetsFile = generateGlobalSnippets globalSnippets;

      script = ''
        mkdir -p ${snippetDir}
        $VERBOSE_ECHO 'Generating VSCode user snippets'
        ${generateUserSnippetFiles}
        $VERBOSE_ECHO 'Generating VSCode global snippets'
        ${generateGlobalSnippetsFile}
      '';
    in lib.hm.dag.entryAfter [ "writeBoundary" ] script;
  };

}
