{
  empty = {
    plugins.persistence.enable = true;
  };

  defaults = {
    plugins.persistence = {
      enable = true;

      settings = {
        branch = true;
        dir.__raw = ''vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/")'';
        need = 1;
      };
    };
  };
}
