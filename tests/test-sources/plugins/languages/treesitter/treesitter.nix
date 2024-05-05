{
  empty = {
    plugins.treesitter.enable = true;
  };

  nonix = {
    # TODO: See if we can build parsers (legacy way)
    tests.dontRun = true;
    plugins.treesitter = {
      enable = true;
      nixGrammars = false;
    };
  };

  nixvimInjections = {
    plugins.treesitter = {
      enable = true;
      nixvimInjections = true;

      languageRegister = {
        cpp = "onelab";
        python = [
          "foo"
          "bar"
        ];
      };
    };
  };

  # This needs a custom input
  # custom = {
  #   plugins.treesitter = {
  #     enable = true;
  #     nixGrammars = true;
  #     grammarPackages = [
  #       (build-ts.lib.buildGrammar pkgs {
  #         language = "gleam";
  #         version = "0.25.0";
  #         source = gleam;
  #       })
  #     ];
  #   };
  # };
}
