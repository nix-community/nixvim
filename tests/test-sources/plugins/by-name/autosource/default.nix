{
  empty = {
    plugins.autosource.enable = true;
  };

  defaults = {
    plugins.autosource = {
      enable = true;

      settings = {
        prompt_for_new_file = 1;
        prompt_for_changed_file = 1;
      };
    };
  };
}
