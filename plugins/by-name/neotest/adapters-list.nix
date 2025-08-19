# List of adapter names (without the `neotest-` prefix).
# The corresponding `pkgs.vimPlugins.neotest-NAME` package has to exist.
# When adding a new adapter, update the tests accordingly:
# - Add the adapter to `all-adapters` in `tests/test-sources/plugins/neotest/default.nix`
# - Add a more complete test case in `tests/test-sources/plugins/neotest/NAME.nix`
{
  bash = {
    treesitter-parser = "bash";
  };
  ctest = {
    treesitter-parser = "cpp";
    settingsSuffix = settingsLua: ".setup(${settingsLua})";
  };
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
  foundry = {
    treesitter-parser = "solidity";
  };
  go = {
    treesitter-parser = "go";
  };
  golang = {
    treesitter-parser = "go";
  };
  gradle = {
    treesitter-parser = "kotlin,java";
  };
  gtest = {
    treesitter-parser = "cpp";
  };
  hardhat = {
    treesitter-parser = "javascript";
    packageName = "hardhat-nvim";
  };
  haskell = {
    treesitter-parser = "haskell";
  };
  java = {
    treesitter-parser = "java";
  };
  jest = {
    treesitter-parser = "javascript";
  };
  minitest = {
    treesitter-parser = "ruby";
  };
  pest = {
    treesitter-parser = "php";
  };
  phpunit = {
    treesitter-parser = "php";
  };
  playwright = {
    treesitter-parser = "typescript";
    settingsSuffix = settingsLua: ".adapter(${settingsLua})";
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
  zig = {
    treesitter-parser = "zig";
  };
}
