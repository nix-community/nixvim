{
  example = {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.ctest = {
          enable = true;

          settings = {
            is_test_file.__raw = ''
              function(file_path)
                -- check if path has test in it
                return string.match(file_path, "test") ~= nil
              end
            '';
          };
        };
      };
    };
  };
}
