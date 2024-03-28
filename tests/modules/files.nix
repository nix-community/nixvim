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
}
