{ config, lib, pkgs, ... }:
let cfg = config.modules.cloneRepos;
in {
  options.modules.cloneRepos = {
    enable = lib.mkEnableOption "cloneRepos";

    git.repos = lib.mkOption { default = { }; };
  };

  config = lib.mkIf cfg.enable {
    home.activation.cloneRepos = let
      cloneSingleRepo = cloneCmd: repo: ''
        if [ ! -d $HOME${repo.path} ]
        then
            $DRY_RUN_CMD ${cloneCmd repo.url "$HOME${repo.path}"}
        else
            echo 'Not cloning ${repo.url} because it already exists.' 
        fi
      '';

      cloneSingleGitRepo = cloneSingleRepo
        (url: name: "${pkgs.gitAndTools.gitFull}/bin/git clone ${url} ${name}");

      cloneOrRecurse = dir: key: value:
        let path = "${dir}/${key}";
        in if (builtins.hasAttr "url" value) then
          cloneSingleGitRepo {
            url = value.url;
            path = path;
          }
        else
          lib.concatLines
          (lib.mapAttrsToList (name: value: cloneOrRecurse path name value)
            value);

      gitCloneScript = lib.concatLines
        (lib.mapAttrsToList (name: value: cloneOrRecurse "" name value)
          cfg.git.repos);

      script = lib.concatLines [ gitCloneScript ];
    in lib.hm.dag.entryAfter [ "writeBoundary" ] script;
  };

}
