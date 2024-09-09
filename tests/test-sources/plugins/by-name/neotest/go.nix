{
  example = {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.go = {
          enable = true;

          settings = {
            experimental = {
              test_table = true;
            };
            args = [
              "-count=1"
              "-timeout=60s"
            ];
          };
        };
      };
    };
  };
}
