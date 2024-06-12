{
  empty = {
    plugins.yanky.enable = true;
  };

  example = {
    plugins.yanky = {
      enable = true;

      ring = {
        historyLength = 100;
        storage = "sqlite";
        storagePath.__raw = "vim.fn.stdpath('data') .. '/databases/yanky.db'";
        syncWithNumberedRegisters = true;
        cancelEvent = "update";
        ignoreRegisters = [ "_" ];
        updateRegisterOnCycle = false;
      };
      picker = {
        select = {
          action = "put('p')";
        };
        telescope = {
          enable = true;
          useDefaultMappings = true;
          mappings = {
            i = {
              "<c-g>" = "put('p')";
              "<c-k>" = "put('P')";
              "<c-x>" = "delete()";
              "<c-r>" = "set_register(require('yanky.utils').get_default_register())";
            };
            n = {
              p = "put('p')";
              P = "put('P')";
              d = "delete()";
              r = "set_register(require('yanky.utils').get_default_register())";
            };
          };
        };
      };
      systemClipboard = {
        syncWithRing = true;
      };
      highlight = {
        onPut = true;
        onYank = true;
        timer = 500;
      };
      preserveCursorPosition = {
        enabled = true;
      };
      textobj = {
        enabled = true;
      };
    };
  };
}
