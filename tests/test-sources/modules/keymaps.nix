{helpers, ...}: {
  example = {
    keymaps = [
      {
        key = ",";
        action = "<cmd>echo \"test\"<cr>";
      }
      {
        mode = ["n" "s"];
        key = "<C-p>";
        action = "<cmd>echo \"test\"<cr>";
      }
    ];
  };

  mkKeymaps = {
    keymaps =
      helpers.keymaps.mkKeymaps
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
          action = "function() print('toto') end";
          lua = true;
          options.silent = false;
        }
        {
          mode = ["n" "v"];
          key = "<C-z>";
          action = "bar";
        }
      ];
  };

  mkKeymapsOnEvent = {
    keymaps =
      helpers.keymaps.mkKeymaps
      {
        mode = "x";
        options.silent = true;
      }
      [
        {
          mode = "n";
          key = ",";
          action = "<cmd>echo \"test\"<cr>";
          onEvent = "InsertEnter";
        }
        {
          # raw action using rawType
          key = "<C-p>";
          action.__raw = "function() print('hello') end";
          onEvent = "InsertEnter";
        }
        {
          key = "<C-a>";
          action = "function() print('toto') end";
          lua = true;
          options.silent = false;
          onEvent = "InsertEnter";
        }
        {
          mode = ["n" "v"];
          key = "<C-z>";
          action = "bar";
          onEvent = "InsertEnter";
        }
      ];
  };
}
