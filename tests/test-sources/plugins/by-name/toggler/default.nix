{
  empty = {
    plugins.toggler.enable = true;
  };

  defaults = {
    plugins.toggler = {
      enable = true;
      settings = {
        inverses = { };
        remove_default_keybinds = false;
        remove_default_inverses = false;
        autoselect_longest_match = false;
      };
    };
  };

  example = {
    plugins.toggler = {
      enable = true;
      settings = {
        inverses = {
          vim = "emacs";
          enabled = "disabled";
        };
        remove_default_keybinds = true;
        remove_default_inverses = true;
        autoselect_longest_match = true;
      };
    };
  };
}
