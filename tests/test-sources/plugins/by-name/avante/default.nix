{
  empty = {
    plugins.avante.enable = true;
  };

  defaults = {
    plugins.avante = {
      enable = true;

      settings = {
        debug = false;
        provider = "claude";
        auto_suggestions_provider = "claude";
        tokenizer = "tiktoken";
        system_prompt = ''
          You are an excellent programming expert.
        '';
        providers = {
          openai = {
            endpoint = "https://api.openai.com/v1";
            model = "gpt-4o";
            timeout = 30000;
            extra_request_body = {
              temperature = 0;
              max_tokens = 4096;
            };
          };
          copilot = {
            endpoint = "https://api.githubcopilot.com";
            model = "gpt-4o-2024-05-13";
            proxy = null;
            allow_insecure = false;
            timeout = 30000;
            extra_request_body = {
              temperature = 0;
              max_tokens = 4096;
            };
          };
          azure = {
            endpoint = "";
            deployment = "";
            api_version = "2024-06-01";
            timeout = 30000;
            extra_request_body = {
              temperature = 0;
              max_tokens = 4096;
            };
          };
          claude = {
            endpoint = "https://api.anthropic.com";
            model = "claude-3-5-sonnet-20240620";
            timeout = 30000;
            extra_request_body = {
              temperature = 0;
              max_tokens = 8000;
            };
          };
          gemini = {
            endpoint = "https://generativelanguage.googleapis.com/v1beta/models";
            model = "gemini-1.5-flash-latest";
            timeout = 30000;
            extra_request_body = {
              temperature = 0;
              max_tokens = 4096;
            };
          };
          cohere = {
            endpoint = "https://api.cohere.com/v1";
            model = "command-r-plus-08-2024";
            timeout = 30000;
            extra_request_body = {
              temperature = 0;
              max_tokens = 4096;
            };
          };
        };
        behaviour = {
          auto_suggestions = false;
          auto_set_highlight_group = true;
          auto_set_keymaps = true;
          auto_apply_diff_after_generation = false;
          support_paste_from_clipboard = false;
        };
        history = {
          storage_path.__raw = "vim.fn.stdpath('state') .. '/avante'";
          paste = {
            extension = "png";
            filename = "pasted-%Y-%m-%d-%H-%M-%S";
          };
        };
        highlights = {
          diff = {
            current = "DiffText";
            incoming = "DiffAdd";
          };
        };
        mappings = {
          diff = {
            ours = "co";
            theirs = "ct";
            all_theirs = "ca";
            both = "cb";
            cursor = "cc";
            next = "]x";
            prev = "[x";
          };
          suggestion = {
            accept = "<M-l>";
            next = "<M-]>";
            prev = "<M-[>";
            dismiss = "<C-]>";
          };
          jump = {
            next = "]]";
            prev = "[[";
          };
          submit = {
            normal = "<CR>";
            insert = "<C-s>";
          };
          ask = "<leader>aa";
          edit = "<leader>ae";
          refresh = "<leader>ar";
          toggle = {
            default = "<leader>at";
            debug = "<leader>ad";
            hint = "<leader>ah";
            suggestion = "<leader>as";
          };
          sidebar = {
            switch_windows = "<Tab>";
            reverse_switch_windows = "<S-Tab>";
          };
        };
        windows = {
          position = "right";
          wrap = true;
          width = 30;
          height = 30;
          sidebar_header = {
            align = "center";
            rounded = true;
          };
          input = {
            prefix = "> ";
          };
          edit = {
            border = "rounded";
          };
        };
        diff = {
          autojump = true;
        };
        hints = {
          enabled = true;
        };
      };
    };
  };

  example = {
    plugins.avante = {
      enable = true;

      settings = {
        provider = "claude";
        providers = {
          claude = {
            endpoint = "https://api.anthropic.com";
            model = "claude-3-5-sonnet-20240620";
            extra_request_body = {
              temperature = 0;
              max_tokens = 4096;
            };
          };
        };
        mappings = {
          diff = {
            ours = "co";
            theirs = "ct";
            none = "c0";
            both = "cb";
            next = "]x";
            prev = "[x";
          };
          jump = {
            next = "]]";
            prev = "[[";
          };
        };
        hints.enabled = true;
        windows = {
          wrap = true;
          width = 30;
          sidebar_header = {
            align = "center";
            rounded = true;
          };
        };
        highlights.diff = {
          current = "DiffText";
          incoming = "DiffAdd";
        };
        diff = {
          debug = false;
          autojump = true;
          list_opener = "copen";
        };
      };
    };
  };
}
