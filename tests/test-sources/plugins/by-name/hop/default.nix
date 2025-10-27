{
  empty = {
    plugins.hop.enable = true;
  };

  example = {
    plugins.hop = {
      enable = true;

      settings = {
        keys = "asdghklqwertyuiopzxcvbnmfj";
        quit_key = "<Esc>";
        reverse_distribution = false;
        x_bias = 10;
        teasing = true;
        virtual_cursor = true;
        jump_on_sole_occurrence = true;
        case_insensitive = false;
        dim_unmatched = true;
        direction = "require'hop.hint'.HintDirection.BEFORE_CURSOR";
        hint_position = "require'hop.hint'.HintPosition.BEGIN";
        hint_type = "require'hop.hint'.HintType.OVERLAY";
        match_mappings = [
          "zh"
          "zh_sc"
        ];
      };
    };

    keymaps = [
      {
        key = "f";
        action.__raw = ''
          function()
            require'hop'.hint_char1({
              direction = require'hop.hint'.HintDirection.AFTER_CURSOR,
              current_line_only = true
            })
          end
        '';
        options.remap = true;
      }
      {
        key = "F";
        action.__raw = ''
          function()
            require'hop'.hint_char1({
              direction = require'hop.hint'.HintDirection.BEFORE_CURSOR,
              current_line_only = true
            })
          end
        '';
        options.remap = true;
      }
      {
        key = "t";
        action.__raw = ''
          function()
            require'hop'.hint_char1({
              direction = require'hop.hint'.HintDirection.AFTER_CURSOR,
              current_line_only = true,
              hint_offset = -1
            })
          end
        '';
        options.remap = true;
      }
      {
        key = "T";
        action.__raw = ''
          function()
            require'hop'.hint_char1({
              direction = require'hop.hint'.HintDirection.BEFORE_CURSOR,
              current_line_only = true,
              hint_offset = 1
            })
          end
        '';
        options.remap = true;
      }
    ];
  };

  defaults = {
    plugins.hop = {
      enable = true;

      settings = {
        keys = "asdghklqwertyuiopzxcvbnmfj";
        quit_key = "<Esc>";
        perm_method = "require'hop.perm'.TrieBacktrackFilling";
        reverse_distribution = false;
        x_bias = 10;
        teasing = true;
        virtual_cursor = true;
        jump_on_sole_occurrence = true;
        ignore_injections = false;
        case_insensitive = true;
        create_hl_autocmd = true;
        dim_unmatched = true;
        direction.__raw = "nil";
        hint_position = "require'hop.hint'.HintPosition.BEGIN";
        hint_type = "require'hop.hint'.HintType.OVERLAY";
        hint_offset = 0;
        current_line_only = false;
        uppercase_labels = false;
        yank_register = "";
        extensions.__raw = "nil";
        multi_windows = false;
        excluded_filetypes.__empty = { };
        match_mappings.__empty = { };
      };
    };
  };
}
