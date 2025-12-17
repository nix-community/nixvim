{
  example = {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.minitest = {
          enable = true;

          settings = {
            test_cmd.__raw = ''
              function()
                return {
                  "bundle",
                  "exec",
                  "rails",
                  "test",
                }
              end
            '';
          };
        };
      };
    };
  };
}
