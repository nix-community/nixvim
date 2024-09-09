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
                return vim.tbl_flatten({
                  "bundle",
                  "exec",
                  "rails",
                  "test",
                })
              end
            '';
          };
        };
      };
    };
  };
}
