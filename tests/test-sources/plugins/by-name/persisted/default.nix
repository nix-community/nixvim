{
  empty = {
    plugins.persisted.enable = true;
  };

  defaults = {
    plugins.persisted = {
      enable = true;

      settings = {
        autostart = true;
        should_save.__raw = ''
          function()
            return true
          end
        '';
        save_dir.__raw = "vim.fn.expand(vim.fn.stdpath('data') .. '/sessions/')";
        follow_cwd = true;
        use_git_branch = false;
        autoload = false;
        on_autoload_no_session.__raw = "function() end";
        allowed_dirs.__empty = { };
        ignored_dirs.__empty = { };
        telescope = {
          mappings = {
            copy_session = "<C-c>";
            change_branch = "<C-b>";
            delete_session = "<C-d>";
          };
          icons = {
            selected = " ";
            dir = "  ";
            branch = " ";
          };
        };
      };
    };
  };

  example = {
    plugins.gitlab = {
      enable = true;

      settings = {
        use_git_branch = true;
        autoload = true;
        on_autoload_no_session.__raw = ''
          function()
            vim.notify("No existing session to load.")
          end
        '';
        should_save.__raw = ''
          function()
            -- Do not save session when the current cwd is git root
            local uv = vim.loop
            local cwd = uv.cwd()
            local git_dir = uv.fs_stat(cwd .. "/.git")
            if git_dir == nil then
              return false
            end

            -- Check if the current buffer is a GIT COMMIT message buffer
            local current_buf = vim.api.nvim_get_current_buf()
            local buf_name = vim.api.nvim_buf_get_name(current_buf)
            local is_git_commit = buf_name:match("COMMIT_EDITMSG$") ~= nil
            if is_git_commit then
              return false
            end

            if vim.fn.argc() > 0 then
              return false
            end

            return true
          end
        '';
      };
    };
  };
}
