{ lib }:
{
  empty = {
    plugins.codecompanion-history.enable = true;
  };

  defaults = {
    plugins = {
      codecompanion-history.enable = true;
      codecompanion = {
        enable = true;
        settings.extensions.history = {
          enabled = true;
          opts = {
            default_buf_title = "[CodeCompanion]  ";
            keymap = "gh";
            keymap_description = "Browse saved chats";
            save_chat_keymap = "sc";
            save_chat_keymap_description = "Save current chat";
            auto_save = true;
            expiration_days = 0;
            picker = lib.nixvim.mkRaw ''require("codecompanion._extensions.history.pickers").history'';
            picker_keymaps = {
              rename = {
                n = "r";
                i = "<M-r>";
              };
              delete = {
                n = "d";
                i = "<M-d>";
              };
              duplicate = {
                n = "<C-y>";
                i = "<C-y>";
              };
            };
            auto_generate_title = true;
            title_generation_opts = {
              adapter = lib.nixvim.mkRaw "nil";
              model = lib.nixvim.mkRaw "nil";
              refresh_every_n_prompts = 0;
              max_refreshes = 3;
              format_title = lib.nixvim.mkRaw "nil";
            };
            summary = {
              create_summary_keymap = "gcs";
              browse_summaries_keymap = "gbs";
              generation_opts = {
                adapter = lib.nixvim.mkRaw "nil";
                model = lib.nixvim.mkRaw "nil";
                context_size = 90000;
                include_references = true;
                include_tool_outputs = true;
                system_prompt = lib.nixvim.mkRaw "nil";
                format_summary = lib.nixvim.mkRaw "nil";
              };
            };
            continue_last_chat = false;
            delete_on_clearing_chat = false;
            dir_to_save = lib.nixvim.mkRaw ''vim.fn.stdpath("data") .. "/codecompanion-history"'';
            enable_logging = false;
            memory = {
              auto_create_memories_on_summary_generation = true;
              vectorcode_exe = "vectorcode";
              tool_opts.default_num = 10;
              notify = true;
              index_on_startup = false;
            };
            chat_filter = lib.nixvim.mkRaw "nil";
          };
        };
      };
    };
  };

  example = {
    plugins = {
      codecompanion-history.enable = true;
      codecompanion = {
        enable = true;
        settings.extensions.history = {
          enabled = true;
          opts = {
            auto_save = false;
            picker = "snacks";
            continue_last_chat = true;
            title_generation_opts = {
              model = "gpt-4o-mini";
              refresh_every_n_prompts = 3;
            };
            summary.generation_opts.model = "gpt-4o-mini";
            memory = {
              notify = false;
              index_on_startup = true;
            };
          };
        };
      };
    };
  };
}
