{
  empty = {
    plugins.auto-session.enable = true;
  };

  defaults = {
    plugins.auto-session = {
      enable = true;

      settings = {
        enabled = true;
        root_dir.__raw = ''vim.fn.stdpath "data" .. "/sessions/"'';
        auto_save = true;
        auto_restore = true;
        auto_create = true;
        suppressed_dirs.__raw = "nil";
        allowed_dirs.__raw = "nil";
        auto_restore_last_session = false;
        use_git_branch = false;
        lazy_support = true;
        bypass_save_filetypes.__raw = "nil";
        close_unsupported_windows = true;
        args_allow_single_directory = true;
        args_allow_files_auto_save = false;
        continue_restore_on_error = true;
        cwd_change_handling = false;
        log_level = "error";
        session_lens = {
          load_on_setup = true;
          theme_conf.__empty = { };
          previewer = false;
          mappings = {
            delete_session = {
              __unkeyed-1 = "i";
              __unkeyed-2 = "<C-D>";
            };
            alternate_session = [
              "i"
              "<C-S>"
            ];
            copy_session = [
              "i"
              "<C-Y>"
            ];
          };
          session_control = {
            control_dir.__raw = ''vim.fn.stdpath "data" .. "/auto_session/"'';
            control_filename = "session_control.json";
          };
        };
      };
    };
  };
}
