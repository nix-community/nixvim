{
  empty = {
    plugins.multicursors.enable = true;
  };

  example = {
    plugins.multicursors = {
      enable = true;

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
