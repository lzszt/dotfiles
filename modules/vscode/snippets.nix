{
  languageSnippets = {
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
    todo = {
      prefix = [ "todo" ];
      body = [ "$LINE_COMMENT TODO (felix): $0" ];
      description = "Insert a TODO remark";
    };
    section = {
      prefix = [ "section" ];
      body = [''
        $LINE_COMMENT-------------------------------------------------------------
        $LINE_COMMENT $0
        $LINE_COMMENT-------------------------------------------------------------
      ''];
      description = "Insert a section";
    };
  };
}
