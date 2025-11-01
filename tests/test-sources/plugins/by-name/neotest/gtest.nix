{
  example = {
    # We cannot test neotest-gtest as it tries to create file in the upper directory
    # https://github.com/alfaix/neotest-gtest/blob/6e794ac91f4c347e2ea5ddeb23d594f8fc64f2a8/lua/neotest-gtest/utils.lua#L10-L16
    test.runNvim = false;

    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.gtest = {
          enable = true;

          settings = {
            root.__raw = ''
              require("neotest.lib").files.match_root_pattern(
                "compile_commands.json",
                "compile_flags.txt",
                "WORKSPACE",
                ".clangd",
                "init.lua",
                "init.vim",
                "build",
                ".git"
              )
            '';
            debug_adapter = "codelldb";
            is_test_file.__raw = ''
              function(file)
              end
            '';
            history_size = 3;
            parsing_throttle_ms = 10;
            mappings = {
              configure.__raw = "nil";
            };
            summary_view = {
              header_length = 80;
              shell_palette = {
                passed = "\27[32m";
                skipped = "\27[33m";
                failed = "\27[31m";
                stop = "\27[0m";
                bold = "\27[1m";
              };
            };
            extra_args.__empty = { };
            filter_dir.__raw = ''
              function(name, rel_path, root)
              end
            '';
          };
        };
      };
    };
  };
}
