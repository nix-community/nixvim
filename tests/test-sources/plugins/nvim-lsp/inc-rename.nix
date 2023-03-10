{
  empty = {
    plugins.inc-rename.enable = true;
  };

  defaults = {
    plugins.inc-rename = {
      enable = true;
      cmdName = "IncRename";
      hlGroup = "Substitute";
      previewEmptyName = false;
      showMessage = true;
      inputBufferType = null;
      postHook = null;
    };
  };
}
