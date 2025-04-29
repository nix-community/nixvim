{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "goto-preview";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    default_mappings = false;
    height = 30;
    post_open_hook.__raw = ''
      function(_, win)
        -- Close the current preview window with <Esc> or 'q'.
        local function close_window()
          vim.api.nvim_win_close(win, true)
        end
        vim.keymap.set('n', '<Esc>', close_window, { buffer = true })
        vim.keymap.set('n', 'q', close_window, { buffer = true })
      end
    '';
  };
}
