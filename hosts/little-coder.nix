{
  config,
  lib,
  ...
}:

let
  cfg = config.little-coder;
in
{
  options.little-coder = {
    enable = lib.mkEnableOption "little-coder with llama-cpp backend";
    hf-repo = lib.mkOption {
      type = lib.types.str;
      default = "Qwen/Qwen3-4B-GGUF:Q4_K_M";
      description = "Hugging Face model repo to serve with llama-cpp";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8888;
      description = "Port for the llama-cpp server";
    };
  };

  config = lib.mkIf cfg.enable {
    services.llama-cpp = {
      enable = true;
      settings = {
        inherit (cfg) port hf-repo;
      };
    };
  };
}
