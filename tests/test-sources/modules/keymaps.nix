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

  luaError = {
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

    test.assertions = expect: [
      # Failed assertions:
      #  - The option definition `lua' in `<unknown-file>' no longer has any effect; please remove it.
      #  Use a "raw lua" `action` instead;
      #  e.g. `action.__raw = "<lua code>"` or `action = lib.nixvim.mkRaw "<lua code>"`.
      (expect "count" 5)
      (expect "all" "The option definition `lua' in `test-module' no longer has any effect; please remove it.")
      (expect "any" "Full option: `keymaps.\"[definition 1-entry 1]\".lua`")
      (expect "any" "Full option: `keymapsOnEvents.InsertEnter.\"[definition 1-entry 1]\".lua`")
      (expect "any" "Full option: `plugins.lsp.keymaps.extra.\"[definition 1-entry 1]\".lua`")
      (expect "any" "Full option: `plugins.tmux-navigator.keymaps.\"[definition 1-entry 1]\".lua`")
      (expect "any" "Full option: `plugins.barbar.keymaps.first.lua`")
      (expect "all" "Use a \"raw lua\" `action` instead;")
      (expect "all" "e.g. `action.__raw = \"<lua code>\"` or `action = lib.nixvim.mkRaw \"<lua code>\"`.")
    ];

    test.runNvim = false;
    test.buildNixvim = false;
  };
}
