{
  lib,
  ...
}:
{
  empty = {
    plugins.multicursors.enable = true;
  };

  defaults = {
    plugins.multicursors = {
      enable = true;

      settings = {
        DEBUG_MODE = false;
        create_commands = true;
        updatetime = 50;
        nowait = true;
        mode_keys = {
          append = "a";
          change = "c";
          extend = "e";
          insert = "i";
        };
        hint_config = {
          float_opts = {
            border = "none";
          };
          position = "bottom";
        };
        generate_hints = {
          normal = true;
          insert = true;
          extend = true;
          config = {
            column_count.__raw = "nil";
            max_hint_length = 25;
          };
        };
      };
    };
  };

  example = {
    plugins.multicursors = {
      # ERROR: [Hydra.nvim] Option "hint.border" has been deprecated and will be removed on 2024-02-01 -- See hint.float_opts
      # Will be fixed by:
      # https://github.com/smoka7/multicursors.nvim/pull/91
      enable = false;

      settings = {
        DEBUG_MODE = false;
        create_commands = true;
        updatetime = 50;
        nowait = true;
        normal_keys = {
          # to change default lhs of key mapping, change the key
          "," = {
            # assigning `null` to method exits from multi cursor mode
            # assigning `false` to method removes the binding
            method = lib.nixvim.mkRaw "require('multicursors.normal_mode').clear_others";

            # you can pass :map-arguments here
            opts = {
              desc = "Clear others";
            };
          };
          "<C-/>" = {
            method = lib.nixvim.mkRaw ''
              function()
                require('multicursors.utils').call_on_selections(
                  function(selection)
                    vim.api.nvim_win_set_cursor(0, { selection.row + 1, selection.col + 1 })
                    local line_count = selection.end_row - selection.row + 1
                    vim.cmd('normal ' .. line_count .. 'gcc')
                  end
                )
              end
            '';
            opts = {
              desc = "comment selections";
            };
          };
        };
        insert_keys.__raw = "nil";
        extend_keys.__raw = "nil";
        hint_config = {
          type = "window";
          position = "bottom";
          offset = 0;
          border = "none";
          show_name = true;
          funcs.__raw = "nil";
        };
        generate_hints = {
          normal = false;
          insert = false;
          extend = false;
        };
      };
    };
  };
}
