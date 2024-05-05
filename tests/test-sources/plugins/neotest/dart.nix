{
  example = {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.dart = {
          enable = true;

          settings = {
            command = "flutter";
            use_lsp = true;
            custom_test_method_names = [ ];
          };
        };
      };
    };
  };
}
