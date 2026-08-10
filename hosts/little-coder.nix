{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.little-coder;
in
{
  options.little-coder = {
    enable = lib.mkEnableOption "little-coder with llama-swap backend";
    port = lib.mkOption {
      type = lib.types.port;
      default = 8888;
      description = "Port for the llama-swap proxy";
    };
    models = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            hf-repo = lib.mkOption {
              type = lib.types.str;
              description = "Hugging Face repo in the format user/repo:quant";
            };
            extraArgs = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "Extra arguments to pass to llama-server";
            };
          };
        }
      );
      default = {
        "qwen3-4b" = {
          hf-repo = "Qwen/Qwen3-8B-GGUF:Q8_0";
        };
      };
      description = "Models available for little-coder via llama-swap";
    };
  };

  config = lib.mkIf cfg.enable {
    services.llama-swap = {
      enable = true;
      inherit (cfg) port;
      settings = {
        models = lib.mapAttrs (name: modelCfg: {
          cmd = toString [
            (lib.getExe' pkgs.llama-cpp "llama-server")
            "--port \${PORT}"
            "--hf-repo ${modelCfg.hf-repo}"
            "--no-webui"
            modelCfg.extraArgs
          ];
        }) cfg.models;
      };
    };
  };
}
