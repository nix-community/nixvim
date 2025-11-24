{ lib }:
{
  example = {
    keymaps = [
      {
        key = ",";
        action = "<cmd>echo \"test\"<cr>";
      }
      {
        mode = [
          "n"
          "s"
        ];
        key = "<C-p>";
        action = "<cmd>echo \"test\"<cr>";
      }
    ];
  };

  mkKeymaps = {
    keymaps =
      lib.nixvim.keymaps.mkKeymaps
        {
          mode = "x";
          options.silent = true;
        }
        [
          {
            mode = "n";
            key = ",";
            action = "<cmd>echo \"test\"<cr>";
          }
          {
            # raw action using rawType
            key = "<C-p>";
            action.__raw = "function() print('hello') end";
          }
          {
            key = "<C-a>";
            action.__raw = "function() print('toto') end";
            options.silent = false;
          }
          {
            mode = [
              "n"
              "v"
            ];
            key = "<C-z>";
            action = "bar";
          }
          {
            mode = "n";
            key = "<C-h>";
            action.__raw = "function() end";
            options.replace_keycodes = false;
          }
        ];
  };

  mkKeymapsOnEvents = {
    keymapsOnEvents = {
      "InsertEnter" =
        lib.nixvim.keymaps.mkKeymaps
          {
            mode = "x";
            options.silent = true;
          }
          [
            {
              mode = "n";
              key = ",";
              action = "<cmd>echo \"test\"<cr>";
            }
            {
              # raw action using rawType
              key = "<C-p>";
              action.__raw = "function() print('hello') end";
            }
            {
              key = "<C-a>";
              action.__raw = "function() print('toto') end";
              options.silent = false;
            }
            {
              mode = [
                "n"
                "v"
              ];
              key = "<C-z>";
              action = "bar";
            }
          ];
    };
  };

  luaWarning = {
    imports = [
      (lib.modules.setDefaultModuleLocation "test-module" {
        keymaps = [
          {
            lua = true;
            key = "a";
            action = "function() print('keymaps') end";
          }
        ];
        keymapsOnEvents.InsertEnter = [
          {
            lua = true;
            key = "a";
            action = "function() print('keymap on InsertEnter') end";
          }
        ];
        plugins.lsp.keymaps.extra = [
          {
            lua = true;
            key = "a";
            action = "function() print('plugins.lsp.keymaps.extra') end";
          }
        ];
        plugins.tmux-navigator.keymaps = [
          {
            lua = true;
            key = "a";
            action = "function() print('plugins.tmux-navigator.keymaps') end";
          }
        ];
        plugins.barbar.keymaps.first = {
          lua = true;
          key = "a";
          action = "function() print('plugins.barbar.keymaps') end";
        };
      })
    ];

    test.warnings = expect: [
      (expect "count" 1)
      (expect "any" "The `lua` keymap option is deprecated and will be removed")
      (expect "any" "You should use a \"raw\" `action` instead;")
      (expect "any" "e.g. `action.__raw = \"<lua code>\"` or `action = lib.nixvim.mkRaw \"<lua code>\"`.")
      (expect "any" "- `keymaps.\"[definition 1-entry 1]\".lua' is defined in `test-module'")
      (expect "any" "- `keymapsOnEvents.InsertEnter.\"[definition 1-entry 1]\".lua' is defined in `test-module'")
      (expect "any" "- `plugins.lsp.keymaps.extra.\"[definition 1-entry 1]\".lua' is defined in `test-module'")
      (expect "any" "- `plugins.tmux-navigator.keymaps.\"[definition 1-entry 1]\".lua' is defined in `test-module'")
      (expect "any" "- `plugins.barbar.keymaps.first.lua' is defined in `test-module'")
    ];

    test.runNvim = false;
  };
}
