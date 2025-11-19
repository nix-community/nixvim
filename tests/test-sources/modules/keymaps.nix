{ lib, ... }:
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
}
