{
  empty = {
    # ERROR: [Hydra.nvim] Option "hint.border" has been deprecated and will be removed on 2024-02-01 -- See hint.float_opts
    # Will be fixed by:
    # https://github.com/smoka7/multicursors.nvim/pull/91
    plugins.multicursors.enable = false;
  };

  example = {
    plugins.multicursors = {
      # ERROR: [Hydra.nvim] Option "hint.border" has been deprecated and will be removed on 2024-02-01 -- See hint.float_opts
      # Will be fixed by:
      # https://github.com/smoka7/multicursors.nvim/pull/91
      enable = false;

      debugMode = false;
      createCommands = true;
      updatetime = 50;
      nowait = true;
      normalKeys = {
        # to change default lhs of key mapping, change the key
        "," = {
          # assigning `null` to method exits from multi cursor mode
          # assigning `false` to method removes the binding
          method = "require 'multicursors.normal_mode'.clear_others";

          # you can pass :map-arguments here
          opts = {desc = "Clear others";};
        };
        "<C-/>" = {
          method = ''
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
          opts = {desc = "comment selections";};
        };
      };
      insertKeys = null;
      extendKeys = null;
      hintConfig = {
        type = "window";
        position = "bottom";
        offset = 0;
        border = "none";
        showName = true;
        funcs = null;
      };
      generateHints = {
        normal = false;
        insert = false;
        extend = false;
      };
    };
  };
}
