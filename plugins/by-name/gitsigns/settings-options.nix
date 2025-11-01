lib:
let
  inherit (lib.nixvim) defaultNullOpts mkNullOrLuaFn;
in
{
  on_attach = mkNullOrLuaFn ''
    Callback called when attaching to a buffer. Mainly used to setup keymaps
    when `config.keymaps` is empty. The buffer number is passed as the first
    argument.

    This callback can return `false` to prevent attaching to the buffer.

    Example:
    ```lua
      function(bufnr)
        if vim.api.nvim_buf_get_name(bufnr):match(<PATTERN>) then
          -- Don't attach to specific buffers whose name matches a pattern
          return false
        end
        -- Setup keymaps
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'hs', '<cmd>lua require"gitsigns".stage_hunk()<CR>', {})
        ... -- More keymaps
      end
    ```
  '';

  status_formatter = defaultNullOpts.mkLuaFn ''
    function(status)
      local added, changed, removed = status.added, status.changed, status.removed
      local status_txt = {}
      if added and added > 0 then
        table.insert(status_txt, '+' .. added)
      end
      if changed and changed > 0 then
        table.insert(status_txt, '~' .. changed)
      end
      if removed and removed > 0 then
        table.insert(status_txt, '-' .. removed)
      end
      return table.concat(status_txt, ' ')
    end
  '' "Function used to format `b:gitsigns_status`.";
}
