{
  empty = {
    plugins.neotest.enable = true;
  };

  example = {
    plugins.neotest = {
      enable = true;
      adapters = {
        dart.enable = true;
        deno.enable = true;
        dotnet.enable = true;
        elixir.enable = true;
        go.enable = true;
        haskell.enable = true;
        jest.enable = true;
        pest.enable = true;
        phpunit.enable = true;
        plenary.enable = true;
        pytest.enable = true;
        python-unittest.enable = true;
        rspec.enable = true;
        rust.enable = true;
        scala.enable = true;
        testthat.enable = true;
        vitest.enable = true;
      };
    };
  };
}
