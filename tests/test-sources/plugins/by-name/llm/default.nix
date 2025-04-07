{
  empty = {
    plugins.llm.enable = true;
  };

  no-package = {
    test.runNvim = false;

    plugins.llm = {
      enable = true;

      settings.lsp.bin_path = null;
    };
    dependencies.llm-ls.enable = false;
  };

  defaults = {
    plugins.llm = {
      enable = true;

      settings = {
        api_token = null;
        model = "bigcode/starcoder2-15b";
        backend = "huggingface";
        url = null;
        tokens_to_clear = [ "<|endoftext|>" ];
        request_body = {
          parameters = {
            max_new_tokens = 60;
            temperature = 0.2;
            top_p = 0.95;
          };
        };
        fim = {
          enabled = true;
          prefix = "<fim_prefix>";
          middle = "<fim_middle>";
          suffix = "<fim_middle>";
        };
        debounce_ms = 150;
        accept_keymap = "<Tab>";
        dismiss_keymap = "<S-Tab>";
        tls_skip_verify_insecure = false;
        lsp = {
          host = null;
          port = null;
          cmd_env = null;
        };
        tokenizer = null;
        context_window = 1024;
        enable_suggestions_on_startup = true;
        enable_suggestions_on_files = "*";
        disable_url_path_completion = false;
      };
    };
  };

  example = {
    plugins.llm = {
      enable = true;

      settings = {
        max_tokens = 1024;
        url = "https://open.bigmodel.cn/api/paas/v4/chat/completions";
        model = "glm-4-flash";
        prefix = {
          user = {
            text = "😃 ";
            hl = "Title";
          };
          assistant = {
            text = "⚡ ";
            hl = "Added";
          };
        };
        save_session = true;
        max_history = 15;
        keys = {
          "Input:Submit" = {
            mode = "n";
            key = "<cr>";
          };
          "Input:Cancel" = {
            mode = "n";
            key = "<C-c>";
          };
          "Input:Resend" = {
            mode = "n";
            key = "<C-r>";
          };
          "Input:HistoryNext" = {
            mode = "n";
            key = "<C-j>";
          };
          "Input:HistoryPrev" = {
            mode = "n";
            key = "<C-k>";
          };
          "Output:Ask" = {
            mode = "n";
            key = "i";
          };
          "Output:Cancel" = {
            mode = "n";
            key = "<C-c>";
          };
          "Output:Resend" = {
            mode = "n";
            key = "<C-r>";
          };
          "Session:Toggle" = {
            mode = "n";
            key = "<leader>ac";
          };
          "Session:Close" = {
            mode = "n";
            key = "<esc>";
          };
        };
      };
    };
  };
}
