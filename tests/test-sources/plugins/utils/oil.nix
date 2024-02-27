{
  empty = {
    plugins.oil.enable = true;
  };

  example = {
    plugins.oil = {
      enable = true;

      columns = {
        type = {
          enable = true;
          highlight = "Foo";
          icons = {};
        };
        icon = {
          enable = true;
          highlight = "Foo";
          defaultFile = "bar";
          directory = "dir";
        };
        size = {
          enable = true;
          highlight = "Foo";
        };
        permissions = {
          enable = true;
          highlight = "Foo";
        };
        ctime = {
          enable = true;
          highlight = "Foo";
          format = "format";
        };
        mtime = {
          enable = true;
          highlight = "Foo";
          format = "format";
        };
        atime = {
          enable = true;
          highlight = "Foo";
          format = "format";
        };
        birthtime = {
          enable = true;
          highlight = "Foo";
          format = "format";
        };
      };
      bufOptions = {
        buflisted = false;
        bufhidden = "hide";
      };
      winOptions = {
        wrap = false;
        signcolumn = "no";
        cursorcolumn = false;
        foldcolumn = "0";
        spell = false;
        list = false;
        conceallevel = 3;
        concealcursor = "n";
      };
      defaultFileExplorer = true;
      restoreWinOptions = true;
      skipConfirmForSimpleEdits = false;
      deleteToTrash = false;
      trashCommand = "trash-put";
      promptSaveOnSelectNewEntry = true;
      lspRenameAutosave = true;
      cleanupDelayMs = 500;
      keymaps = {
        "g?" = "actions.show_help";
        "<CR>" = "actions.select";
        "<C-s>" = "actions.select_vsplit";
        "<C-h>" = "actions.select_split";
        "<C-t>" = "actions.select_tab";
        "<C-p>" = "actions.preview";
        "<C-c>" = "actions.close";
        "<C-l>" = "actions.refresh";
        "-" = "actions.parent";
        "_" = "actions.open_cwd";
        "`" = "actions.cd";
        "~" = "actions.tcd";
        "g." = "actions.toggle_hidden";
      };
      useDefaultKeymaps = true;
      viewOptions = {
        showHidden = false;
        isHiddenFile = ''
          function(name, bufnr)
            return vim.startswith(name, ".")
          end
        '';
        isAlwaysHidden = ''
          function(name, bufnr)
            return false
          end
        '';
      };
      float = {
        padding = 2;
        maxWidth = 0;
        maxHeight = 0;
        border = "rounded";
        winOptions = {
          winblend = 10;
        };
      };
      preview = {
        maxWidth = 0.9;
        minWidth = [40 0.4];
        width = null;
        maxHeight = 0.9;
        minHeight = [5 0.1];
        height = null;
        border = "rounded";
        winOptions = {
          winblend = 0;
        };
      };
      progress = {
        maxWidth = 0.9;
        minWidth = [40 0.4];
        width = null;
        maxHeight = 0.9;
        minHeight = [5 0.1];
        height = null;
        border = "rounded";
        minimizedBorder = "none";
        winOptions = {
          winblend = 0;
        };
      };
    };
  };
}
