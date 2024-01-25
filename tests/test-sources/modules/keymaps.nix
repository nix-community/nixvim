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
}
