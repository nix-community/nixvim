{
  empty = {
    plugins.persistence.enable = true;
  };

  defaults = {
    plugins.persistence = {
      enable = true;

      dir.__raw = ''vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/")'';
      options = [
        "buffers"
        "curdir"
        "tabpages"
        "winsize"
      ];
      preSave = null;
      saveEmpty = false;
    };
  };
}
