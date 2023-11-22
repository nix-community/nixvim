# List of adapter names (without the `neotest-` prefix).
# The corresponding `pkgs.vimPlugins.neotest-NAME` package has to exist.
# When adding a new adapter, update the tests accordingly:
# - Add the adapter to `all-adapters` in `tests/test-sources/plugins/neotest/default.nix`
# - Add a more complete test case in `tests/test-sources/plugins/neotest/NAME.nix`
{
  dart = {
    treesitter-parser = "dart";
  };
  deno = {
    treesitter-parser = "javascript";
  };
  dotnet = {
    treesitter-parser = "c_sharp";
  };
  elixir = {
    treesitter-parser = "elixir";
  };
  go = {
    treesitter-parser = "go";
  };
  haskell = {
    treesitter-parser = "haskell";
  };
  jest = {
    treesitter-parser = "javascript";
  };
  pest = {
    treesitter-parser = "php";
  };
  phpunit = {
    treesitter-parser = "php";
  };
  plenary = {
    treesitter-parser = "lua";
  };
  python = {
    treesitter-parser = "python";
  };
  rspec = {
    treesitter-parser = "ruby";
  };
  rust = {
    treesitter-parser = "rust";
  };
  scala = {
    treesitter-parser = "scala";
  };
  testthat = {
    treesitter-parser = "r";
  };
  vitest = {
    treesitter-parser = "javascript";
  };
}
