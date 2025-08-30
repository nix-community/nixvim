{ lib, ... }:
let
  inherit (lib.nixvim)
    defaultNullOpts
    mkNullOrStr'
    mkNullOrStr
    ;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "codecompanion";
  packPathName = "codecompanion.nvim";
  package = "codecompanion-nvim";
  description = "AI-powered coding, seamlessly in Neovim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    adapters = defaultNullOpts.mkAttrsOf' {
      type = types.anything;
      pluginDefault = {
        anthropic = "anthropic";
        azure_openai = "azure_openai";
        copilot = "copilot";
        deepseek = "deepseek";
        gemini = "gemini";
        githubmodels = "githubmodels";
        huggingface = "huggingface";
        novita = "novita";
        mistral = "mistral";
        ollama = "ollama";
        openai = "openai";
        xai = "xai";
        non_llms = {
          jina = "jina";
          tavily = "tavily";
        };
        opts = {
          allow_insecure = false;
          cache_models_for = 1800;
          proxy = null;
          show_defaults = true;
          show_model_choices = true;
        };
      };
      example = {
        openai.__raw = ''
          function()
            return require("codecompanion.adapters").extend("openai", {
              schema = {
                model = {
                  default = "gpt-4o"
                }
              }
            })
          end
        '';
        ollama.__raw = ''
          function()
            return require("codecompanion.adapters").extend("ollama", {
              schema = {
                model = {
                  default = "llama3:latest"
                }
              }
            })
          end
        '';
      };
      description = ''
        In CodeCompanion, adapters are interfaces that act as a bridge between the plugin's
        functionality and an LLM.

        Refer to the [documentation](https://github.com/olimorris/codecompanion.nvim/blob/main/doc/configuration/adapters.md)
        to learn about the adapters spec.
      '';
    };

    strategies = defaultNullOpts.mkAttrsOf' {
      type = types.anything;
      pluginDefault = lib.literalExpression "See upstream documentation";
      example = {
        chat.adapter = "ollama";
        inline.adapter = "ollama";
        agent.adapter = "ollama";
      };
      description = ''
        The plugin utilises objects called Strategies.
        These are the different ways that a user can interact with the plugin.
        - The _chat_ strategy harnesses a buffer to allow direct conversation with the LLM.
        - The _inline_ strategy allows for output from the LLM to be written directly into a
          pre-existing Neovim buffer.
        - The _agent_ and _workflow_ strategies are wrappers for the _chat_ strategy, allowing
          for tool use and agentic workflows.
      '';
    };

    prompt_library = defaultNullOpts.mkAttrsOf' {
      type = types.submodule {
        freeformType = with types; attrsOf anything;
        options = {
          strategy = mkNullOrStr ''
            The plugin utilises objects called Strategies.
            These are the different ways that a user can interact with the plugin.
            - The _chat_ strategy harnesses a buffer to allow direct conversation with the LLM.
            - The _inline_ strategy allows for output from the LLM to be written directly into a
              pre-existing Neovim buffer.
            - The _agent_ and _workflow_ strategies are wrappers for the _chat_ strategy, allowing
              for tool use and agentic workflows.
          '';

          description = mkNullOrStr' {
            description = ''
              A description for this recipe.
            '';
            example = "Explain the LSP diagnostics for the selected code";
          };
        };
      };
      pluginDefault = lib.literalExpression "See upstream documentation";
      example = {
        "Custom Prompt" = {
          strategy = "inline";
          description = "Prompt the LLM from Neovim";
          opts = {
            index = 3;
            is_default = true;
            is_slash_cmd = false;
            user_prompt = true;
          };
          prompts = [
            {
              role.__raw = "system";
              content.__raw = ''
                function(context)
                  return fmt(
                    [[I want you to act as a senior %s developer. I will ask you specific questions and I want you to return raw code only (no codeblocks and no explanations). If you can't respond with code, respond with nothing]],
                    context.filetype
                  )
                end
              '';
            }
          ];
        };
        "Generate a Commit Message" = {
          strategy = "chat";
          description = "Generate a commit message";
          opts = {
            index = 10;
            is_default = true;
            is_slash_cmd = true;
            short_name = "commit";
            auto_submit = true;
          };
          prompts = [
            {
              role = "user";
              content.__raw = ''
                function()
                  return fmt(
                    [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

                    ```diff
                    %s
                    ```
                    ]],
                    vim.fn.system("git diff --no-ext-diff --staged")
                  )
                end
              '';
              opts = {
                contains_code = true;
              };
            }
          ];
        };
      };
      description = ''
        The plugin comes with a number of pre-built prompts.

        As per the config, these can be called via keymaps or via the cmdline.
        These prompts have been carefully curated to mimic those in GitHub's Copilot Chat.

        Of course, you can create your own prompts and add them to the Action Palette or even to the
        slash command completion menu in the chat buffer.
        Please see the [Creating Prompts](https://github.com/olimorris/codecompanion.nvim/blob/main/doc/extending/prompts.md)
        guide for more information.
      '';
    };

    display = defaultNullOpts.mkNullable' {
      type = types.submodule {
        freeformType = with types; attrsOf anything;
      };
      example = {
        display = {
          action_palette = {
            provider = "default";
            opts.show_default_prompt_library = true;
          };
          chat = {
            window = {
              layout = "vertical";
              opts.breakindent = true;
            };
          };
        };
      };
      pluginDefault = lib.literalExpression "See upstream documentation";
      description = ''
        Appearance settings.
      '';
    };

    opts = defaultNullOpts.mkNullable' {
      type = types.submodule {
        freeformType = with types; attrsOf anything;
      };
      description = ''
        General settings for the plugin.
      '';
      example = {
        log_level = "TRACE";
        send_code = true;
        use_default_actions = true;
        use_default_prompts = true;
      };
      pluginDefault = lib.literalExpression "See upstream documentation";
    };
  };

  settingsExample = {
    adapters = {
      http.ollama.__raw = ''
        function()
          return require('codecompanion.adapters').extend('ollama', {
              env = {
                  url = "http://127.0.0.1:11434",
              },
              schema = {
                  model = {
                      default = 'qwen2.5-coder:latest',
                      -- default = "llama3.1:8b-instruct-q8_0",
                  },
                  num_ctx = {
                      default = 32768,
                  },
              },
          })
        end
      '';
    };
    strategies = {
      chat.adapter = "ollama";
      inline.adapter = "ollama";
      agent.adapter = "ollama";
    };
    opts = {
      log_level = "TRACE";
      send_code = true;
      use_default_actions = true;
      use_default_prompts = true;
    };
  };
}
