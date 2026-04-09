{
  empty = {
    # vim-kitty-navigator now eagerly shells out to `kitten`, but nixvim does
    # not provide the Kitty terminal runtime.
    test.runNvim = false;

    plugins.kitty-navigator.enable = true;
  };

  defaults = {
    # vim-kitty-navigator now eagerly shells out to `kitten`, but nixvim does
    # not provide the Kitty terminal runtime.
    test.runNvim = false;

    plugins.kitty-navigator = {
      enable = true;

      settings = {
        enable_stack_layout = 0;
      };
    };
  };

  example = {
    # vim-kitty-navigator now eagerly shells out to `kitten`, but nixvim does
    # not provide the Kitty terminal runtime.
    test.runNvim = false;

    plugins.kitty-navigator = {
      enable = true;

      settings = {
        enable_stack_layout = 1;
      };
    };
  };
}
