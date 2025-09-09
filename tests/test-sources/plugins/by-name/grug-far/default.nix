{ lib, ... }:
# Disable as luajitPackages.grug-far-nvim is flaky
lib.optionalAttrs false {
  empty = {
    plugins.grug-far.enable = true;
  };

  # Just a small subset of the settings
  defaults = {
    plugins.grug-far = {
      enable = true;

      settings = {
        debounceMs = 500;
        minSearchChars = 2;
        maxSearchMatches = 2000;
        normalModeSearch = false;
        maxWorkers = 4;
        engine = "ripgrep";
        engines = {
          ripgrep = {
            path = "rg";
            extraArgs = "";
            showReplaceDiff = true;
            placeholders = {
              enabled = true;
              search = "ex: foo   foo([a-z0-9]*)   fun\\(";
              replacement = ''ex: bar   $${1}_foo   $$MY_ENV_VAR'';
              replacement_lua = ''ex: if vim.startsWith(match; "use") \\n then return "employ" .. match \\n else return match end'';
              filesFilter = ''ex: *.lua   *.{css;js}   **/docs/*.md   (specify one per line)'';
              flags = "ex: --help --ignore-case (-i) --replace= (empty replace) --multiline (-U)";
              paths = "ex: /foo/bar   ../   ./hello\\ world/   ./src/foo.lua   ~/.config";
            };
          };
        };
      };
    };
  };

  example = {
    plugins.grug-far = {
      enable = true;
      settings = {
        debounceMs = 1000;
        minSearchChars = 1;
        maxSearchMatches = 2000;
        normalModeSearch = false;
        maxWorkers = 8;
        engine = "ripgrep";
        engines = {
          ripgrep = {
            path = "rg";
            showReplaceDiff = true;
          };
        };
      };
    };
  };
}
