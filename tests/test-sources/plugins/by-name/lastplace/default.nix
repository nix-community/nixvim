{
  empty = {
    plugins.lastplace.enable = true;
  };

  defaults = {
    plugins.lastplace = {
      enable = true;

      settings = {
        lastplace_ignore_buftype = [
          "quickfix"
          "nofix"
          "help"
        ];
        lastplace_ignore_filetype = [
          "gitcommit"
          "gitrebase"
          "svn"
          "hgcommit"
        ];
        lastplace_open_folds = true;
      };
    };
  };
}
