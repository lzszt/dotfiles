{ config, lib, pkgs, ... }:
let cfg = config.modules.cloneRepos;
in {
  options.modules.cloneRepos = {
    enable = lib.mkEnableOption "cloneRepos";
    repos = lib.mkOption { default = [ ]; };
  };
  config = lib.mkIf cfg.enable {
    home.activation.cloneRepos = let
      cloneSingleRepo = repo: ''
        mkdir -p $HOME/${repo.dir}
        cd $HOME/${repo.dir}

        if [ ! -d $HOME/${repo.dir}/${repo.name} ]
        then
            $DRY_RUN_CMD ${pkgs.gitAndTools.gitFull}/bin/git clone ${repo.url} ${repo.name}
        else
            echo 'Not cloning ${repo.url} because it already exists.' 
        fi
      '';
      script = lib.concatLines (builtins.map cloneSingleRepo cfg.repos);
    in lib.hm.dag.entryAfter [ "writeBoundary" ] script;
  };

}
