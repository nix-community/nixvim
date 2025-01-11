{
  empty = {
    plugins.cornelis.enable = true;
  };

  defaults = {
    plugins.cornelis = {
      enable = true;

      settings = {
        use_global_binary = 0;
        agda_prefix = "<localleader>";
        no_agda_input = 0;
        bind_input_hook = null;
      };
    };
  };

  example = {
    plugins.cornelis = {
      enable = true;

      settings = {
        use_global_binary = 1;
        agda_prefix = "<Tab>";
        no_agda_input = 1;
        bind_input_hook = "MyCustomHook";
      };
    };
  };
}
