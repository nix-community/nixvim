{
  empty = {
    plugins.web-devicons.enable = true;
    plugins.trouble.enable = true;
  };

  lsp = {
    plugins.web-devicons.enable = true;
    plugins.lsp = {
      enable = true;
      servers.clangd.enable = true;
    };

    plugins.trouble.enable = true;
  };

  defaults = {
    plugins.web-devicons.enable = true;
    plugins.trouble = {
      enable = true;

      settings = {
        position = "bottom";
        height = 10;
        width = 50;
        icons = true;
        mode = "workspace_diagnostics";
        fold_open = "";
        fold_closed = "";
        group = true;
        padding = true;
        action_keys = {
          close = "q";
          cancel = "<esc>";
          refresh = "r";
          jump = [
            "<cr>"
            "<tab>"
          ];
          open_split = [ "<c-x>" ];
          open_vsplit = [ "<c-v>" ];
          open_tab = [ "<c-t>" ];
          jump_close = [ "o" ];
          toggle_mode = "m";
          toggle_preview = "P";
          hover = "K";
          preview = "p";
          close_folds = [
            "zM"
            "zm"
          ];
          open_folds = [
            "zR"
            "zr"
          ];
          toggle_fold = [
            "zA"
            "za"
          ];
          previous = "k";
          next = "j";
        };
        indent_lines = true;
        win_config = {
          border = "single";
        };
        auto_open = false;
        auto_close = false;
        auto_preview = true;
        auto_fold = false;
        auto_jump = [ "lsp_definitions" ];
        signs = {
          error = "";
          warning = "";
          hint = "";
          information = "";
          other = "﫠";
        };
        use_diagnostic_signs = false;
      };
    };
  };

  no-icons = {
    plugins.web-devicons.enable = false;
    plugins.trouble = {
      enable = true;
    };
  };
}
