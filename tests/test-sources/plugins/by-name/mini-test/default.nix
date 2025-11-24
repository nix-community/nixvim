{ lib }:
{
  empty = {
    plugins.mini-test.enable = true;
  };

  defaults = {
    plugins.mini-test = {
      enable = true;
      settings = {
        collect = {
          emulate_busted = true;
          find_files = lib.nixvim.mkRaw ''
            function()
              return vim.fn.globpath('tests', '**/test_*.lua', true, true)
            end
          '';
          filter_cases = lib.nixvim.mkRaw "function(case) return true end";
        };

        execute = {
          reporter = lib.nixvim.mkRaw "nil";
          stop_on_error = false;
        };

        script_path = "scripts/minitest.lua";
        silent = false;
      };
    };
  };
}
