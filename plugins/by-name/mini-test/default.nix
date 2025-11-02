{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-test";
  moduleName = "mini.test";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    collect = {
      emulate_busted = true;
      find_files = lib.nixvim.nestedLiteralLua ''
        function()
          return vim.fn.globpath('tests', '**/test_*.lua', true, true)
        end
      '';
      filter_cases = lib.nixvim.nestedLiteralLua "function(case) return true end";
    };

    execute = {
      reporter = lib.nixvim.nestedLiteralLua "nil";
      stop_on_error = false;
    };

    script_path = "scripts/minitest.lua";
    silent = false;
  };
}
