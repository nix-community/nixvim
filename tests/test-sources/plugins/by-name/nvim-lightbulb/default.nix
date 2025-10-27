{
  empty = {
    plugins.nvim-lightbulb.enable = true;
  };

  defaults = {
    plugins.nvim-lightbulb = {
      enable = true;

      settings = {
        priority = 10;
        hide_in_unfocused_buffer = true;
        link_highlights = true;
        validate_config = "auto";
        action_kinds.__raw = "nil";
        sign = {
          enabled = true;
          text = "💡";
          hl = "LightBulbSign";
        };
        virtual_text = {
          enabled = false;
          text = "💡";
          pos = "eol";
          hl = "LightBulbVirtualText";
          hl_mode = "combine";
        };
        float = {
          enabled = false;
          text = "💡";
          hl = "LightBulbFloatWin";
          win_opts.__empty = { };
        };
        status_text = {
          enabled = false;
          text = "💡";
          text_unavailable = "";
        };
        number = {
          enabled = false;
          hl = "LightBulbNumber";
        };
        line = {
          enabled = false;
          hl = "LightBulbLine";
        };
        autocmd = {
          enabled = false;
          updatetime = 200;
          pattern = [ "*" ];
          events = [
            "CursorHold"
            "CursorHoldI"
          ];
        };
        ignore = {
          clients.__empty = { };
          ft.__empty = { };
          actions_without_kind = false;
        };
      };
    };
  };

  example = {
    plugins.nvim-lightbulb = {
      enable = true;

      settings = {
        sign = {
          enabled = false;
          text = "󰌶";
        };
        virtual_text = {
          enabled = true;
          text = "󰌶";
        };
        float = {
          enabled = false;
          text = " 󰌶 ";
          win_opts.border = "rounded";
        };
        status_text = {
          enabled = false;
          text = " 󰌶 ";
        };
        number = {
          enabled = false;
        };
        line = {
          enabled = false;
        };
        autocmd = {
          enabled = true;
          updatetime = 200;
        };
      };
    };
  };
}
