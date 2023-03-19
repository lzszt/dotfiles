{ config, lib, pkgs, ... }:
let cfg = config.modules.cloneRepos;
in {
  options.modules.cloneRepos = {
    enable = lib.mkEnableOption "cloneRepos";

    git.repos = lib.mkOption { default = [ ]; };
  };

  config = lib.mkIf cfg.enable {
    home.activation.cloneRepos = let
      cloneSingleRepo = cloneCmd: repo: ''
        mkdir -p $HOME/${repo.dir}
        cd $HOME/${repo.dir}

        if [ ! -d $HOME/${repo.dir}/${repo.name} ]
        then
            $DRY_RUN_CMD ${cloneCmd repo.url repo.name}
        else
            echo 'Not cloning ${repo.url} because it already exists.' 
        fi
      '';

      cloneSingleGitRepo = cloneSingleRepo
        (url: name: "${pkgs.gitAndTools.gitFull}/bin/git clone ${url} ${name}");

      gitCloneScript =
        lib.concatLines (builtins.map cloneSingleGitRepo cfg.git.repos);
      script = lib.concatLines [
        gitCloneScript
      ];
    in lib.hm.dag.entryAfter [ "writeBoundary" ] script;
  };

}
