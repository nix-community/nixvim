{
  empty = {
    plugins.nvim-autopairs.enable = true;
  };

  defaults = {
    plugins.nvim-autopairs = {
      enable = true;

      settings = {
        disable_filetype = [
          "TelescopePrompt"
          "spectre_panel"
        ];
        disable_in_macro = false;
        disable_in_visualblock = false;
        disable_in_replace_mode = true;
        ignored_next_char = "[=[[%w%%%'%[%\"%.%`%$]]=]";
        enable_moveright = true;
        enable_afterquote = true;
        enable_check_bracket_line = true;
        enable_bracket_in_quote = true;
        enable_abbr = false;
        break_undo = true;
        check_ts = false;
        ts_config = {
          lua = [
            "string"
            "source"
            "string_content"
          ];
          javascript = [
            "string"
            "template_string"
          ];
        };
        map_cr = true;
        map_bs = true;
        map_c_h = false;
        map_c_w = false;
        fast_wrap = {
          map = "<M-e>";
          chars = [
            "{"
            "["
            "("
            "\""
            "'"
          ];
          pattern = ''[=[[%'%"%>%]%)%}%,%`]]=]'';
          end_key = "$";
          before_key = "h";
          after_key = "l";
          cursor_pos_before = true;
          keys = "qwertyuiopzxcvbnmasdfghjkl";
          highlight = "Search";
          highlight_grey = "Comment";
          manual_position = true;
          use_virt_lines = true;
        };
      };
    };
  };
}
