{ lib }:
{
  empty = {
    plugins.substitute.enable = true;
  };

  defaults = {
    plugins.substitute = {
      enable = true;
      settings = {
        on_substitute = lib.nixvim.mkRaw "nil";
        yank_substituted_text = false;
        preserve_cursor_position = false;
        modifiers = lib.nixvim.mkRaw "nil";

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
          subject = lib.nixvim.mkRaw "nil";
          range = lib.nixvim.mkRaw "nil";
          register = lib.nixvim.mkRaw "nil";
          suffix = "";
          auto_apply = false;
          cursor_position = "end";
        };
        exchange = {
          motion = lib.nixvim.mkRaw "nil";
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
        on_substitute = lib.nixvim.mkRaw ''
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
