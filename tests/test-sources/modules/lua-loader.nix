{
  # Test that nothing is configured by default
  default =
    { config, lib, ... }:
    {
      files."files_test.lua" = { };

      assertions = [
        {
          assertion = !lib.hasInfix "vim.loader" config.content;
          message = "No luaLoader configuration is expected in init.lua by default.";
        }
        {
          assertion = !lib.hasInfix "vim.loader" config.files."files_test.lua".content;
          message = "No luaLoader configuration is expected in 'files' submodules.";
        }
      ];
    };

  # Test Lua loader enabled
  enabled =
    { config, lib, ... }:
    {
      luaLoader.enable = true;

      files."files_test.lua" = { };

      assertions = [
        {
          assertion = lib.hasInfix "vim.loader.enable(true)" config.content;
          message = "luaLoader is expected to be explicitly enabled.";
        }
        {
          assertion = !lib.hasInfix "vim.loader" config.files."files_test.lua".content;
          message = "No luaLoader configuration is expected in 'files' submodules.";
        }
      ];
    };

  # Test Lua loader disabled
  disabled =
    { config, lib, ... }:
    {
      luaLoader.enable = false;

      files."files_test.lua" = { };

      assertions = [
        {
          assertion = lib.hasInfix "vim.loader.enable(false)" config.content;
          message = "luaLoader is expected to be explicitly disabled.";
        }
        {
          assertion = !lib.hasInfix "vim.loader." config.files."files_test.lua".content;
          message = "No luaLoader configuration is expected in 'files' submodules.";
        }
      ];
    };
}
