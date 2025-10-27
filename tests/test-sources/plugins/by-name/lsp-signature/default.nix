{
  empty = {
    plugins.lsp-signature.enable = true;
  };

  example = {
    plugins.lsp-signature = {
      enable = true;

      settings = {
        debug = true;
        log_path = "~/.config/TestDirectory/lsp_signature.log";
        verbose = true;
        bind = true;
        doc_lines = 5;

        max_height = 10;
        max_width = 45;
        wrap = false;
        floating_window = true;
        floating_window_above_cur_line = false;
        floating_window_off_x = "function() return 1 end";
        fix_pos = true;
        hint_inline = "function() return 'inline' end";
        handler_opts.border = "shadow";
        extra_trigger_chars = [ "$" ];

        shadow_blend = 1;
        select_signature_key = "<C-c>";
      };
    };
  };

  defaults = {
    plugins.lsp-signature = {
      enable = true;

      settings = {
        debug = false;
        log_path = # lua
          ''
            vim.fn.stdpath("cache") .. "/lsp_signature.log"
          '';
        verbose = false;
        bind = true;
        doc_lines = 10;
        max_height = 12;
        max_width = 80;
        wrap = true;
        floating_window = true;
        floating_window_above_cur_line = true;
        floating_window_off_x = 1;
        floating_window_off_y = 0;
        close_timeout = 4000;
        fix_pos = false;
        hint_enable = true;
        hint_prefix = "🐼 ";
        hint_scheme = "String";
        hint_inline = # lua
          ''
            function() return false end
          '';
        hi_parameter = "LspSignatureActiveParameter";
        handler_opts.border = "rounded";
        always_trigger = false;
        auto_close_after.__raw = "nil";
        extra_trigger_chars.__empty = { };
        zindex = 200;
        padding = "";
        transparency.__raw = "nil";
        shadow_blend = 36;
        shadow_guibg = "Green";
        time_interval = 200;
        toggle_key.__raw = "nil";
        toggle_flip_floatwin_setting = false;
        select_signature_key.__raw = "nil";
        move_cursor_key.__raw = "nil";
        keymaps.__empty = { };
      };
    };
  };
}
