{
  empty = {
    plugins.lastplace.enable = true;
  };

  # All the upstream default options of lastplace
  defaults = {
    plugins.lastplace = {
      enable = true;

      ignoreBuftype = ["quickfix" "nofix" "help"];
      ignoreFiletype = ["gitcommit" "gitrebase" "svn" "hgcommit"];
      openFolds = true;
    };
  };
}
