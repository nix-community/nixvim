{
  example = {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.vitest = {
          enable = true;

          settings = {
            filter_dir.__raw = ''
              function(name, rel_path, root)
                return name ~= "node_modules"
              end
            '';
          };
        };
      };
    };
  };
}
