{
  empty = {
    plugins.substitute.enable = true;
  };

  defaults = {
    plugins.substitute = {
      enable = true;
      settings = {
        on_substitute.__raw = "nil";
        yank_substituted_text = false;
        preserve_cursor_position = false;
        modifiers.__raw = "nil";
        highlight_substituted_text = {
          enabled = true;
          timer = 500;
        };
        range = {
          prefix = "s";
          prompt_current_text = false;
          confirm = false;
          complete_word = false;
          group_substituted_text = false;
          subject.__raw = "nil";
          range.__raw = "nil";
          register.__raw = "nil";
          suffix = "";
          auto_apply = false;
          cursor_position = "end";
        };
        exchange = {
          motion.__raw = "nil";
          use_esc_to_cancel = true;
          preserve_cursor_position = false;
        };
      };
    };
  };

  example = {
    plugins.substitute = {
      enable = true;
      settings = {
        on_substitute.__raw = ''
          function(params)
            vim.notify("substituted using register " .. params.register)
          end
        '';
        yank_substituted_text = true;
        modifiers = [
          "join"
          "trim"
        ];
        highlight_substituted_text.timer = 750;
        range = {
          prefix = "S";
          complete_word = true;
          confirm = true;
          subject.motion = "iw";
          range.motion = "ap";
          suffix = "| call histdel(':', -1)";
          auto_apply = true;
          cursor_position = "start";
        };
        exchange = {
          motion = "ap";
          use_esc_to_cancel = false;
          preserve_cursor_position = true;
        };
      };
    };
  };
}
