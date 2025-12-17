{
  empty = {
    plugins.gitsigns.enable = true;
  };

  example = {
    plugins.gitsigns = {
      enable = true;

      settings = {
        signs = {
          add.text = "┃";
          change.text = "┃";
          delete.text = "▁";
          topdelete.text = "▔";
          changedelete.text = "~";
          untracked.text = "┆";
        };
        worktrees = [
          {
            toplevel.__raw = "vim.env.HOME";
            gitdir.__raw = "vim.env.HOME .. '/projects/dotfiles/.git'";
          }
        ];
        on_attach = ''
          function(bufnr)
            if vim.api.nvim_buf_get_name(bufnr):match("test.txt") then
              -- Don't attach to specific buffers whose name matches a pattern
              return false
            end
            -- Setup keymaps
            vim.keymap.set('n', 'hs', '<cmd>lua require"gitsigns".stage_hunk()<CR>', { buffer = bufnr })
          end
        '';
        watch_gitdir = {
          enable = true;
          follow_files = true;
        };
        sign_priority = 6;
        signcolumn = true;
        numhl = false;
        linehl = false;
        diff_opts = {
          algorithm = "myers";
          internal = false;
          indent_heuristic = false;
          vertical = true;
          linematch.__raw = "nil";
          ignore_blank_lines = true;
          ignore_whitespace_change = true;
          ignore_whitespace = true;
          ignore_whitespace_change_at_eol = true;
        };
        base.__raw = "nil";
        count_chars = {
          "__unkeyed_1" = "1";
          "__unkeyed_2" = "2";
          "__unkeyed_3" = "3";
          "__unkeyed_4" = "4";
          "__unkeyed_5" = "5";
          "__unkeyed_6" = "6";
          "__unkeyed_7" = "7";
          "__unkeyed_8" = "8";
          "__unkeyed_9" = "9";
          "+" = ">";
        };
        status_formatter = ''
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
        '';
        max_file_length = 40000;
        preview_config = {
          border = "single";
          style = "minimal";
          relative = "cursor";
          row = 0;
          col = 1;
        };
        auto_attach = true;
        attach_to_untracked = true;
        update_debounce = 100;
        current_line_blame = false;
        current_line_blame_opts = {
          virt_text = true;
          virt_text_pos = "eol";
          delay = 1000;
          ignore_whitespace = false;
          virt_text_priority = 100;
        };
        current_line_blame_formatter = " <author>, <author_time> - <summary> ";
        current_line_blame_formatter_nc = " <author>";
        trouble = false;
        word_diff = false;
        debug_mode = false;
      };
    };
  };
}
