lib:
let
  inherit (lib) types mkOption;
  inherit (lib.nixvim)
    defaultNullOpts
    mkNullOrOption'
    mkNullOrStr
    mkNullOrStr'
    ;
in
{
  api_token = mkNullOrStr ''
    Token for authentificating to the backend provider.

    When `api_token` is set, it will be passed as a header: `Authorization: Bearer <api_token>`.
  '';

  model = mkNullOrStr' {
    example = "bigcode/starcoder2-15b";
    description = ''
      The model ID, behavior depends on backend
    '';
  };

  backend = defaultNullOpts.mkStr "huggingface" ''
    Which backend to use for inference.
  '';

  url = defaultNullOpts.mkStr null ''
    The http url of the backend.
  '';

  tokens_to_clear = defaultNullOpts.mkListOf types.str [ "<|endoftext|>" ] ''
    List of tokens to remove from the model's output.
  '';

  request_body = {
    parameters = mkNullOrOption' {
      type = with types; attrsOf anything;
      example = {
        temperature = 0.2;
        top_p = 0.95;
      };
      description = ''
        Parameters for the model.
      '';
    };
  };

  fim = {
    enabled = defaultNullOpts.mkBool true ''
      Set this if the model supports fill in the middle.
    '';

    prefix = defaultNullOpts.mkStr "<fim_prefix>" ''
      The beginning of the text sequence to fill.
    '';

    middle = defaultNullOpts.mkStr "<fim_middle>" ''
      The missing or masked segment that the model should predict.
    '';

    suffix = defaultNullOpts.mkStr "<fim_middle>" ''
      The text following the missing section.
    '';
  };

  debounce_ms = defaultNullOpts.mkUnsignedInt 150 ''
    Time in ms to wait before updating.
  '';

  accept_keymap = defaultNullOpts.mkStr "<Tab>" ''
    Keymap to accept the model suggestion.
  '';

  dismiss_keymap = defaultNullOpts.mkStr "<S-Tab>" ''
    Keymap to dismiss the model suggestion.
  '';

  tls_skip_verify_insecure = defaultNullOpts.mkBool false ''
    Whether to skip TLS verification when accessing the backend.
  '';

  lsp = {
    bin_path = mkNullOrOption' {
      type = types.str;
      defaultText = lib.literalExpression "lib.getExe config.plugins.llm.llmLsPackage";
      description = ''
        Path to the `llm-ls` binary.

        If not set, llm.nvim will try to download the `llm-ls` binary from the internet.
        As this will not work well with Nix, Nixvim is setting this automatically for you.
      '';
    };

    host = defaultNullOpts.mkStr null ''
      You can also use `llm-ls` through TCP by providing a hostname.
    '';

    port = defaultNullOpts.mkUnsignedInt null ''
      The port for connecting to a `llm-ls` TCP instance.
    '';

    cmd_env = defaultNullOpts.mkAttrsOf' {
      type = types.anything;
      pluginDefault = null;
      example = {
        LLM_LOG_LEVEL = "DEBUG";
      };
      description = ''
        Use this option to set environment variables for the `llm-ls` process.
      '';
    };
  };

  tokenizer = defaultNullOpts.mkNullable' {
    pluginDefault = null;
    example.path = "/path/to/my/tokenizer.json";
    description = ''
      `llm-ls` uses tokenizers to make sure the prompt fits the `context_window`.

      To configure it, you have a few options:
      - No tokenization: `llm-ls` will count the number of characters instead
        Leave this option set to `null` (default)
      - From a local file on your disk. Set the `path` attribute.
      - From a Hugging Face repository: `llm-ls` will attempt to download `tokenizer.json` at the root
        of the repository
      - From an HTTP endpoint: `llm-ls` will attempt to download a file via an HTTP GET request
    '';
    type =
      let
        localFile = types.submodule {
          options = {
            path = mkOption {
              type = types.str;
              example = "/path/to/my/tokenizer.json";
            };
          };
        };

        huggingFaceRepository = types.submodule {
          options = {
            repository = mkOption {
              type = types.str;
              example = "myusername/myrepo";
              description = "Location of the repository.";
            };

            api_token = defaultNullOpts.mkStr null ''
              Optional, in case the API token used for the backend is not the same.
            '';
          };
        };

        httpEndpoint = types.submodule {
          options = {
            url = mkOption {
              type = types.str;
              example = "https://my-endpoint.example.com/mytokenizer.json";
              description = "URL of the HTTP endpoint";
            };

            to = mkOption {
              type = types.str;
              example = "/download/path/of/mytokenizer.json";
              description = "Download path.";
            };
          };
        };
      in
      with types;
      maybeRaw (oneOf [
        localFile
        huggingFaceRepository
        httpEndpoint
      ]);
  };

  context_window = defaultNullOpts.mkUnsignedInt 1024 ''
    Size of the context window (in tokens).
  '';

  enable_suggestions_on_startup = defaultNullOpts.mkBool true ''
    Lets you choose to enable or disable "suggest-as-you-type" suggestions on neovim startup.

    You can then toggle auto suggest with `LLMToggleAutoSuggest`.
  '';

  enable_suggestions_on_files = defaultNullOpts.mkNullable' {
    type = with types; maybeRaw (either str (listOf str));
    pluginDefault = "*";
    example = [
      "*.py"
      "*.rs"
    ];
    description = ''
      Lets you enable suggestions only on specific files that match the pattern matching syntax you
      will provide.

      It can either be a string or a list of strings, for example:
      - to match on all types of buffers: `"*"`
      - to match on all files in my_project/: `"/path/to/my_project/*"`
      - to match on all python and rust files: `[ "*.py" "*.rs" ]`
    '';
  };

  disable_url_path_completion = defaultNullOpts.mkBool false ''
    `llm-ls` will try to add the correct path to the url to get completions if it does not already
    end with said path.

    You can disable this behavior by setting this option to `true`.
  '';
}
