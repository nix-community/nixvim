{
  example = {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.scala = {
          enable = true;

          settings = {
            args = [ "--no-color" ];
            runner = "bloop";
            framework = "utest";
          };
        };
      };
    };
  };
}
