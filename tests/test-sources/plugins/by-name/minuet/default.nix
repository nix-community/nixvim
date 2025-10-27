{
  empty = {
    plugins.minuet.enable = true;
  };

  defaults = {
    plugins.minuet = {
      enable = true;

      settings = {
        cmp = {
          enable_auto_complete = true;
        };
        blink = {
          enable_auto_complete = true;
        };
        lsp = {
          enabled_ft.__empty = { };
          disabled_ft.__empty = { };
          enabled_auto_trigger_ft.__empty = { };
          disabled_auto_trigger_ft.__empty = { };
          warn_on_blink_or_cmp = true;
        };
        virtualtext = {
          auto_trigger_ft.__empty = { };
          auto_trigger_ignore_ft.__empty = { };
          keymap = {
            accept.__raw = "nil";
            accept_line.__raw = "nil";
            accept_n_lines.__raw = "nil";
            next.__raw = "nil";
            prev.__raw = "nil";
            dismiss.__raw = "nil";
          };
          show_on_completion_menu = false;
        };
        provider = "codestral";
        context_window = 16000;
        context_ratio = 0.75;
        throttle = 1000;
        debounce = 400;
        notify = "warn";
        request_timeout = 3;
        add_single_line_entry = true;
        n_completions = 3;
        after_cursor_filter_length = 15;
        proxy.__raw = "nil";
        provider_options.__empty = { };
        default_system = {
          template = "...";
          prompt = "...";
          guidelines = "...";
          n_completion_template = "...";
        };
        default_system_prefix_first = {
          template = "...";
          prompt = "...";
          guidelines = "...";
          n_completion_template = "...";
        };
        default_fim_template = {
          prompt = "...";
          suffix = "...";
        };
        default_few_shots = [ "..." ];
        default_chat_input = [ "..." ];
        default_few_shots_prefix_first = [ "..." ];
        default_chat_input_prefix_first = [ "..." ];
        presets.__empty = { };
      };
    };
  };

  example = {
    plugins.minuet = {
      enable = true;

      settings = {
        provider = "openai_compatible";
        provider_options = {
          openai_compatible = {
            api_key = "OPENROUTER_API_KEY";
            end_point = "https://openrouter.ai/api/v1/chat/completions";
            name = "OpenRouter";
            model = "google/gemini-flash-1.5";
            stream = true;
            optional = {
              max_tokens = 256;
              top_p = 0.9;
            };
          };
        };
      };
    };
  };
}
