{ pkgs, ... }:
let
  pluginStubs = pkgs.callPackage ../../../utils/plugin-stubs.nix { };

  pluginWithRuntimeDep = pluginStubs.mkPlugin "plugin_with_runtime_dep" {
    runtimeDeps = [ pkgs.hello ];
  };

  # With `autowrapRuntimeDeps`, `hello` reaches the wrapper's PATH only through
  # this plugin's `runtimeDeps`.
  runtimeDepCheck = # lua
    ''
      assert(
        vim.fn.executable("hello") == 1,
        "'hello' is not in PATH, expected the plugin runtimeDeps to be wrapped"
      )
    '';
in
{
  combined =
    { config, lib, ... }:
    {
      performance.combinePlugins.enable = true;
      extraPlugins = [ pluginWithRuntimeDep ];
      extraConfigLuaPost = runtimeDepCheck;

      # The test runner checks assertions before it launches nvim, so a
      # regression names the missing dependency instead of failing in Lua.
      assertions = [
        {
          assertion = lib.elem pkgs.hello config.build.nvimPackage.runtimeDeps;
          message = "`combinePlugins` should keep plugin runtime dependencies.";
        }
      ];
    };

  # Control case: the same stub without combining, so a `combined` failure
  # points at the pack code.
  not-combined = {
    performance.combinePlugins.enable = false;
    extraPlugins = [ pluginWithRuntimeDep ];
    extraConfigLuaPost = runtimeDepCheck;
  };
}
