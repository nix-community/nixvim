{
  example = {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.haskell = {
          enable = true;

          settings = {
            build_tools = [
              "stack"
              "cabal"
            ];
            frameworks = [
              "tasty"
              "hspec"
              "sydtest"
            ];
          };
        };
      };
    };
  };
}
