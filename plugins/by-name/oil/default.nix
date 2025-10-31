{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "oil";
  package = "oil-nvim";
  description = "Neovim file explorer: edit your filesystem like a buffer.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    view_options = {
      is_hidden_file = lib.nixvim.defaultNullOpts.mkLuaFn ''
        function(name, bufnr)
          return vim.startswith(name, ".")
        end
      '' "This function defines what is considered a 'hidden' file.";

      is_always_hidden = lib.nixvim.defaultNullOpts.mkLuaFn ''
        function(name, bufnr)
          return false
        end
      '' "This function defines what will never be shown, even when `show_hidden` is set.";
    };

    float = {
      override =
        lib.nixvim.defaultNullOpts.mkLuaFn
          ''
            function(conf)
              return conf
            end
          ''
          ''
            This is the config that will be passed to `nvim_open_win`.
            Change values here to customize the layout.
          '';
    };
  };

  settingsExample = {
    columns = [ "icon" ];
    view_options.show_hidden = false;
    win_options = {
      wrap = false;
      signcolumn = "no";
      cursorcolumn = false;
      foldcolumn = "0";
      spell = false;
      list = false;
      conceallevel = 3;
      concealcursor = "ncv";
    };
    keymaps = {
      "<C-c>" = false;
      "<leader>qq" = "actions.close";
      "<C-l>" = false;
      "<C-r>" = "actions.refresh";
      "y." = "actions.copy_entry_path";
    };
    skip_confirm_for_simple_edits = true;
  };
}
