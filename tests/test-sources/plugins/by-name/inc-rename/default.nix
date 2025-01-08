{
  empty = {
    plugins.inc-rename.enable = true;
  };

  defaults = {
    plugins.inc-rename = {
      enable = true;

      settings = {
        cmd_name = "IncRename";
        hl_group = "Substitute";
        preview_empty_name = false;
        show_message = true;
        save_in_cmdline_history = true;
        input_buffer_type = null;
        post_hook = null;
      };
    };
  };

  example = {
    plugins.inc-rename = {
      enable = true;

      settings = {
        input_buffer_type = "dressing";
        preview_empty_name = false;
        show_message.__raw = ''
          function(msg)
            vim.notify(msg, vim.log.levels.INFO, { title = "Rename" })
          end
        '';
      };
    };
  };
}
