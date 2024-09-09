{
  defaults = {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.rspec = {
          enable = true;

          settings = {
            rspec_cmd.__raw = ''
              function()
                return vim.tbl_flatten({
                  "bundle",
                  "exec",
                  "rspec",
                })
              end
            '';
            root_files = [
              "Gemfile"
              ".rspec"
              ".gitignore"
            ];
            filter_dirs = [
              ".git"
              "node_modules"
            ];
            transform_spec_path.__raw = ''
              function(path)
                return path
              end
            '';
            results_path.__raw = ''
              function()
                return async.fn.tempname()
              end
            '';
          };
        };
      };
    };
  };
}
