{
  empty = {
    plugins.wtf.enable = true;
  };

  example = {
    plugins.wtf = {
      enable = true;

      keymaps = {
        ai.key = "gw";
        search = {
          mode = [
            "n"
            "x"
          ];
          options.desc = "Search diagnostic with Google";
        };
      };
      popupType = "popup";
      openaiApiKey = null;
      openaiModelId = "gpt-3.5-turbo";
      language = "english";
      additionalInstructions = "Hello world !";
      searchEngine = "google";
      hooks = {
        requestStarted = ''
          function()
            vim.cmd("hi StatusLine ctermbg=NONE ctermfg=yellow")
          end
        '';
        requestFinished = ''
          vim.schedule_wrap(function()
            vim.cmd("hi StatusLine ctermbg=NONE ctermfg=NONE")
          end)
        '';
      };
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder";
    };
  };
}
