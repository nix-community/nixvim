{
  after = {
    files."after/ftplugin/python.lua" = {
      localOpts.conceallevel = 1;

      keymaps = [
        {
          mode = "n";
          key = "<C-g>";
          action = ":!python script.py<CR>";
          options.silent = true;
        }
      ];
    };
  };

  vim-type = {
    files."plugin/default_indent.vim".opts = {
      shiftwidth = 2;
      expandtab = true;
    };

    extraConfigLuaPost = ''
      vim.cmd.runtime("plugin/default_indent.vim")
      assert(vim.o.shiftwidth == 2, "shiftwidth is not set")
      assert(vim.o.expandtab, "expandtab is not set")
    '';
  };
}
