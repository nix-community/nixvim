{
  # Test that nothing is configured by default
  default.module =
    { config, ... }:
    {
      files."files_test.lua" = { };

      assertions = [
        {
          assertion = builtins.match ".*vim\.loader.*" config.content == null;
          message = "No luaLoader configuration is expected in init.lua by default.";
        }
        {
          assertion = builtins.match ".*vim\.loader.*" config.files."files_test.lua".content == null;
          message = "No luaLoader configuration is expected in 'files' submodules.";
        }
      ];
    };

  # Test lua loader enabled
  enabled.module =
    { config, ... }:
    {
      luaLoader.enable = true;

      files."files_test.lua" = { };

      assertions = [
        {
          assertion = builtins.match ".*vim\.loader\.enable\(\).*" config.content != null;
          message = "luaLoader is expected to be explicitly enabled.";
        }
        {
          assertion = builtins.match ".*vim\.loader.*" config.files."files_test.lua".content == null;
          message = "No luaLoader configuration is expected in 'files' submodules.";
        }
      ];
    };

  # Test lua loader disabled
  disabled.module =
    { config, ... }:
    {
      luaLoader.enable = false;

      files."files_test.lua" = { };

      assertions = [
        {
          assertion = builtins.match ".*vim\.loader\.disable\(\).*" config.content != null;
          message = "luaLoader is expected to be explicitly disabled.";
        }
        {
          assertion = builtins.match ".*vim\.loader.*" config.files."files_test.lua".content == null;
          message = "No luaLoader configuration is expected in 'files' submodules.";
        }
      ];
    };
}
