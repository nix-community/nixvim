{
  empty = {
    plugins.lastplace.enable = true;
  };

  defaults = {
    plugins.lastplace = {
      enable = true;

      ignoreBuftype = [
        "quickfix"
        "nofix"
        "help"
      ];
      ignoreFiletype = [
        "gitcommit"
        "gitrebase"
        "svn"
        "hgcommit"
      ];
      openFolds = true;
    };
  };
}
