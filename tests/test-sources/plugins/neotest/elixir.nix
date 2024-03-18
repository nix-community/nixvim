{
  example = {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.elixir = {
          enable = true;

          settings = {
            mix_task = ["my_custom_task"];
            extra_formatters = ["ExUnit.CLIFormatter" "ExUnitNotifier"];
            extra_block_identifiers = ["test_with_mock"];
            args = ["--trace"];
            post_process_command.__raw = ''
              function(cmd)
                return vim.tbl_flatten({{"env", "FOO=bar"}, cmd})
              end
            '';
            write_delay = 1000;
          };
        };
      };
    };
  };
}
