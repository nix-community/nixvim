{
  empty = {
    plugins.whitespace.enable = true;
  };

  defaults = {
    plugins.whitespace = {
      enable = true;
      settings = {
        highlight = "DiffDelete";
        ignored_filetypes = [
          "TelescopePrompt"
          "Trouble"
          "help"
          "dashboard"
        ];
        ignore_terminal = true;
        return_cursor = true;
      };
    };
  };
}
