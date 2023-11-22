{
  example = {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.plenary = {
          enable = true;

          settings = {
            min_init = "./path/to/test_init.lua";
          };
        };
      };
    };
  };
}
