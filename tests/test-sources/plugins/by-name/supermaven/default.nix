# We don't run neovim here, as supermaven tries to download `sm-agent`
{
  empty = {
    test.runNvim = false;
    plugins.supermaven.enable = true;
  };

  defaults = {
    test.runNvim = false;
    plugins.supermaven = {
      enable = true;

      settings = {
        keymaps = {
          accept_suggestion = "<Tab>";
          clear_suggestions = "<C-]>";
          accept_word = "<C-j>";
        };
        ignore_filetypes.__empty = { };
        color = {
          suggestion_color.__raw = "nil";
          cterm.__raw = "nil";
        };
        log_level = "info";
        disable_inline_completion = false;
        disable_keymaps = false;
        condition.__raw = ''
          function()
            return false
          end
        '';
      };
    };
  };

  example = {
    test.runNvim = false;
    plugins.supermaven = {
      enable = true;

      settings = {
        keymaps = {
          accept_suggestion = "<Tab>";
          clear_suggestions = "<C-]>";
          accept_word = "<C-j>";
        };
        ignore_filetypes = [ "cpp" ];
        color = {
          suggestion_color = "#ffffff";
          cterm = 244;
        };
        log_level = "info";
        disable_inline_completion = false;
        disable_keymaps = false;
        condition.__raw = ''
          function()
            return false
          end
        '';
      };
    };
  };
}
