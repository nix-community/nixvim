{
  empty = {
    plugins.kitty-navigator.enable = true;
  };

  defaults = {
    plugins.kitty-navigator = {
      enable = true;

      settings = {
        enable_stack_layout = 0;
      };
    };
  };

  example = {
    plugins.kitty-navigator = {
      enable = true;

      settings = {
        enable_stack_layout = 1;
      };
    };
  };
}
