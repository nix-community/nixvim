{
  example = {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.java = {
          enable = true;

          settings = {
            ignore_wrapper = false;
          };
        };
      };
    };
  };
}
