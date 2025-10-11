{ lib, ... }:
{
  empty = {
    plugins.wtf.enable = true;
  };

  example = {
    plugins.wtf = {
      enable = true;

      settings = {
        popup_type = "popup";
        providers.openai = {
          api_key = lib.nixvim.mkRaw "vim.env.OPENAI_API_KEY";
          model_id = "gpt-3.5-turbo";
        };
        language = "english";
        search_engine = "phind";
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder";
      };
    };
  };

  defaults = {
    plugins.wtf = {
      enable = true;

      settings = {
        additional_instructions = null;
        chat_dir = lib.nixvim.mkRaw "vim.fn.stdpath('data'):gsub('/$', \"\") .. '/wtf/chats'";
        language = "english";
        picker = "telescope";
        popup_type = "horizontal";
        provider = "openai";
        search_engine = "google";
        # Extracting the default value would be annoying
        # providers = create_provider_defaults()
        hooks = {
          request_started = null;
          request_finished = null;
        };
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder";
      };
    };
  };
}
