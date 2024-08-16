{
  # Test that nothing is configured by default
  default.module =
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
  enabled.module =
    { config, lib, ... }:
    {
      luaLoader.enable = true;

      files."files_test.lua" = { };

      assertions = [
        {
          assertion = lib.hasInfix "vim.loader.enable()" config.content;
          message = "luaLoader is expected to be explicitly enabled.";
        }
        {
          assertion = !lib.hasInfix "vim.loader" config.files."files_test.lua".content;
          message = "No luaLoader configuration is expected in 'files' submodules.";
        }
      ];
    };

  # Test Lua loader disabled
  disabled.module =
    { config, lib, ... }:
    {
      luaLoader.enable = false;

      files."files_test.lua" = { };

      assertions = [
        {
          assertion = lib.hasInfix "vim.loader.disable()" config.content;
          message = "luaLoader is expected to be explicitly disabled.";
        }
        {
          assertion = !lib.hasInfix "vim.loader." config.files."files_test.lua".content;
          message = "No luaLoader configuration is expected in 'files' submodules.";
        }
      ];
    };
}
