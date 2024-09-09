{
  example = {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.jest = {
          enable = true;

          settings = {
            jestCommand = "npm test --";
            jestConfigFile = "custom.jest.config.ts";
            env = {
              CI = true;
            };
            cwd.__raw = ''
              function(path)
                return vim.fn.getcwd()
              end
            '';
          };
        };
      };
    };
  };
}
