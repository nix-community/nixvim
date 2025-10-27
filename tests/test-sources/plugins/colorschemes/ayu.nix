{
  empty = {
    colorschemes.ayu.enable = true;
  };

  defaults = {
    colorschemes.ayu = {
      enable = true;

      settings = {
        mirage = false;

        # FIXME: this can't be empty due to raw coercion
        overrides = { };
      };
    };
  };
}
