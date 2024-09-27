{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.ollama;

  actionOptionType =
    with lib.types;
    oneOf [
      rawLua
      (enum [
        "display"
        "replace"
        "insert"
        "display_replace"
        "display_insert"
        "display_prompt"
      ])
      (submodule {
        options = {
          fn = helpers.mkNullOrStrLuaFnOr (enum [ false ]) ''
            fun(prompt: table): Ollama.PromptActionResponseCallback

            Example:
            ```lua
              function(prompt)
                -- This function is called when the prompt is selected
                -- just before sending the prompt to the LLM.
                -- Useful for setting up UI or other state.

                -- Return a function that will be used as a callback
                -- when a response is received.
                ---@type Ollama.PromptActionResponseCallback
                return function(body, job)
                  -- body is a table of the json response
                  -- body.response is the response text received

                  -- job is the plenary.job object when opts.stream = true
                  -- job is nil otherwise
                end

              end
            ```
          '';

          opts = {
            stream = helpers.defaultNullOpts.mkBool false ''
              Whether to stream the response.
            '';
          };
        };
      })
    ];
in
{
  meta.maintainers = [ maintainers.GaetanLepage ];

  options.plugins.ollama = helpers.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "ollama.nvim";

    package = lib.mkPackageOption pkgs "ollama.nvim" {
      default = [
        "vimPlugins"
        "ollama-nvim"
      ];
    };

    model = helpers.defaultNullOpts.mkStr "mistral" ''
      The default model to use.
    '';

    prompts =
      let
        promptOptions = {
          prompt = mkOption {
            type = with lib.types; maybeRaw str;
            description = ''
              The prompt to send to the model.

              Replaces the following tokens:
              - `$input`: The input from the user
              - `$sel`: The currently selected text
              - `$ftype`: The filetype of the current buffer
              - `$fname`: The filename of the current buffer
              - `$buf`: The contents of the current buffer
              - `$line`: The current line in the buffer
              - `$lnum`: The current line number in the buffer
            '';
          };

          inputLabel = helpers.defaultNullOpts.mkStr "> " ''
            The label to use for an input field.
          '';

          action = helpers.mkNullOrOption actionOptionType ''
            How to handle the output.

            See [here](https://github.com/nomnivore/ollama.nvim/tree/main#actions) for more details.

            Defaults to the value of `plugins.ollama.action`.
          '';

          model = helpers.mkNullOrStr ''
            The model to use for this prompt.

            Defaults to the value of `plugins.ollama.model`.
          '';

          extract =
            helpers.defaultNullOpts.mkNullable (with lib.types; maybeRaw (either str (enum [ false ])))
              "```$ftype\n(.-)```"
              ''
                A `string.match` pattern to use for an Action to extract the output from the response
                (Insert/Replace).
              '';

          options = helpers.mkNullOrOption (with types; attrsOf anything) ''
            Additional model parameters, such as temperature, listed in the documentation for the [Modelfile](https://github.com/jmorganca/ollama/blob/main/docs/modelfile.md#valid-parameters-and-values).
          '';

          system = helpers.mkNullOrStr ''
            The SYSTEM instruction specifies the system prompt to be used in the Modelfile template,
            if applicable.
            (overrides what's in the Modelfile).
          '';

          format = helpers.defaultNullOpts.mkEnumFirstDefault [ "json" ] ''
            The format to return a response in.
            Currently the only accepted value is `"json"`.
          '';
        };

        processPrompt =
          prompt:
          if isAttrs prompt then
            {
              inherit (prompt) prompt;
              input_label = prompt.inputLabel;
              inherit (prompt)
                action
                model
                extract
                options
                system
                format
                ;
            }
          else
            prompt;
      in
      mkOption {
        type = with types; attrsOf (either (submodule { options = promptOptions; }) (enum [ false ]));
        default = { };
        apply = v: mapAttrs (_: processPrompt) v;
        description = ''
          A table of prompts to use for each model.
          Default prompts are defined [here](https://github.com/nomnivore/ollama.nvim/blob/main/lua/ollama/prompts.lua).
        '';
      };

    action = helpers.defaultNullOpts.mkNullable actionOptionType "display" ''
      How to handle prompt outputs when not specified by prompt.

      See [here](https://github.com/nomnivore/ollama.nvim/tree/main#actions) for more details.
    '';

    url = helpers.defaultNullOpts.mkStr "http://127.0.0.1:11434" ''
      The url to use to connect to the ollama server.
    '';

    serve = {
      onStart = helpers.defaultNullOpts.mkBool false ''
        Whether to start the ollama server on startup.
      '';

      command = helpers.defaultNullOpts.mkStr "ollama" ''
        The command to use to start the ollama server.
      '';

      args = helpers.defaultNullOpts.mkListOf types.str [ "serve" ] ''
        The arguments to pass to the serve command.
      '';

      stopCommand = helpers.defaultNullOpts.mkStr "pkill" ''
        The command to use to stop the ollama server.
      '';

      stopArgs =
        helpers.defaultNullOpts.mkListOf types.str
          [
            "-SIGTERM"
            "ollama"
          ]
          ''
            The arguments to pass to the stop command.
          '';
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];

    extraConfigLua =
      let
        setupOptions =
          with cfg;
          {
            inherit
              model
              prompts
              action
              url
              ;
            serve = with serve; {
              on_start = onStart;
              inherit command args;
              stop_command = stopCommand;
              stop_args = stopArgs;
            };
          }
          // cfg.extraOptions;
      in
      ''
        require('ollama').setup(${helpers.toLuaObject setupOptions})
      '';
  };
}
