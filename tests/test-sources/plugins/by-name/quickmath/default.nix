{
  empty = {
    plugins.quickmath.enable = true;
  };

  example = {
    plugins.quickmath = {
      enable = true;

      keymap = {
        key = "<leader>q";
        silent = true;
      };
    };
  };
}
