# Not including defaults are they are too big
{
  minimal = {
    # lua/parrot/provider/init.lua:11: config.api_key is required
    test.runNvim = false;

    plugins.parrot = {
      enable = true;

      settings.providers.github.__empty = null;
    };
  };

  example = {
    # lua/parrot/provider/init.lua:11: config.api_key is required
    test.runNvim = false;

    plugins.parrot = {
      enable = true;

      # https://github.com/frankroeder/parrot.nvim?tab=readme-ov-file#configuration
      settings = {
        providers = {
          anthropic = {
            api_key.__raw = "os.getenv('ANTHROPIC_API_KEY')";
            endpoint = "https://api.anthropic.com/v1/messages";
            topic_prompt = "You only respond with 3 to 4 words to summarize the past conversation.";
            topic = {
              model = "claude-3-haiku-20240307";
              params.max_tokens = 32;
            };
            params = {
              chat.max_tokens = 4096;
              command.max_tokens = 4096;
            };
            models = [
              "claude-3-haiku-20240307"
              "claude-3-opus-20240229"
              "claude-3-sonnet-20240229"
            ];
          };
        };
        cmd_prefix = "Prt";
        curl_params.__empty = { };
        state_dir.__raw = "vim.fn.stdpath('data'):gsub('/$', '') .. '/parrot/persisted'";
        chat_dir.__raw = "vim.fn.stdpath('data'):gsub('/$', '') .. '/parrot/chats'";
        chat_user_prefix = "🗨:";
        llm_prefix = "🦜:";
        chat_confirm_delete = true;
        online_model_selection = false;
        chat_shortcut_respond = {
          modes = [
            "n"
            "i"
            "v"
            "x"
          ];
          shortcut = "<C-g><C-g>";
        };
        chat_shortcut_delete = {
          modes = [
            "n"
            "i"
            "v"
            "x"
          ];
          shortcut = "<C-g>d";
        };
        chat_shortcut_stop = {
          modes = [
            "n"
            "i"
            "v"
            "x"
          ];
          shortcut = "<C-g>s";
        };
        chat_shortcut_new = {
          modes = [
            "n"
            "i"
            "v"
            "x"
          ];
          shortcut = "<C-g>c";
        };
        chat_free_cursor = false;
        chat_prompt_buf_type = false;
        toggle_target = "vsplit";
        user_input_ui = "native";
        style_popup_border = "single";
        style_popup_margin_bottom = 8;
        style_popup_margin_left = 1;
        style_popup_margin_right = 2;
        style_popup_margin_top = 2;
        style_popup_max_width = 160;
        command_prompt_prefix_template = "🤖 {{llm}} ~ ";
        command_auto_select_response = true;
        fzf_lua_opts = {
          "--ansi" = true;
          "--sort" = "";
          "--info" = "inline";
          "--layout" = "reverse";
          "--preview-window" = "nohidden:right:75%";
        };
        enable_spinner = true;
        spinner_type = "star";
        show_context_hints = true;
        show_thinking_window = true;
      };
    };
  };
}
