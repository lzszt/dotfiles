{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.little-coder;

  src = pkgs.fetchFromGitHub {
    owner = "itayinbarr";
    repo = "little-coder";
    rev = "v${version}";
    hash = "sha256-hv3vSPBkDuNl9L7cX71DGs64//Nzur5dGR9006OqgA8=";
  };

  version = "1.14.0";

  # Patch the lockfile to add missing integrity hashes.
  # Match by package name so both top-level and nested entries are fixed.
  integrityByName = builtins.toJSON {
    "@earendil-works/pi-agent-core" =
      "sha512-RorGp9OH5l3ElpuC5a5ZQ2eWcchZGXflXRzVGkV99y3y6tT+LLNyxoYIdVKvTKWEObwhExeQbTH0fI2tE4iX4g==";
    "@earendil-works/pi-ai" =
      "sha512-m3IZD4g3er0V8TC9+Vpgw/sjTKqcJlkcIBy/JvsgRubuuik3tAVzyugUg4rVrShIkkOT69mEd34NEqKUIsl6JQ==";
    "@earendil-works/pi-tui" =
      "sha512-IoYrb0rORjELmEpNtoCA/U8je3KopMkRAVJRdSzvXRvgb+Huo1gNh8Q5CSZvNOiYtDxJdj2tYZZHZ4B3+IN3hA==";
  };

  patchedSrc = pkgs.runCommand "little-coder-patched-source" { inherit src; } ''
        cp -r $src $out
        chmod -R +w $out
        ${pkgs.python3}/bin/python3 -c "
    import json, sys
    fixes = json.loads(sys.argv[2])
    with open(sys.argv[1], 'r') as f:
        lock = json.load(f)
    for key, pkg in lock.get('packages', {}).items():
        if key and 'integrity' not in pkg and 'resolved' in pkg:
            # Extract package name from path (last node_modules/ segment)
            name = key.split('node_modules/')[-1]
            if name in fixes:
                pkg['integrity'] = fixes[name]
    with open(sys.argv[1], 'w') as f:
        json.dump(lock, f, indent=2)
    " "$out/package-lock.json" '${integrityByName}'
  '';

  little-coder = pkgs.buildNpmPackage {
    pname = "little-coder";
    inherit version;

    src = patchedSrc;

    npmDepsHash = "sha256-COzK3eVG3uzstcNztXWLn+uNRQVTVAco++A1fqj9IzE=";
    npmDepsFetcherVersion = 2;
    makeCacheWritable = true;

    npmFlags = [ "--legacy-peer-deps" ];
    forceGitDeps = true;
    dontNpmBuild = true;
  };
in
{
  options.modules.little-coder = {
    enable = lib.mkEnableOption "little-coder";
    model = lib.mkOption {
      type = lib.types.str;
      default = "qwen3-4b";
      description = "Model ID to use with little-coder (must match what llama-cpp is serving)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ little-coder ];
    home.sessionVariables = {
      LLAMACPP_BASE_URL = "http://127.0.0.1:8888/v1";
      LLAMACPP_API_KEY = "noop";
    };
    xdg.configFile."little-coder/models.json".text = builtins.toJSON {
      default = "llamacpp/${cfg.model}";
      providers = {
        llamacpp = {
          api = "openai-completions";
          baseUrl = "http://127.0.0.1:8888/v1";
          apiKey = "LLAMACPP_API_KEY";
          models = [
            {
              id = cfg.model;
              name = "${cfg.model} (local llama.cpp)";
              reasoning = true;
              input = [ "text" ];
              contextWindow = 32768;
              maxTokens = 4096;
              cost = {
                input = 0;
                output = 0;
                cacheRead = 0;
                cacheWrite = 0;
              };
            }
          ];
        };
      };
    };
  };
}
