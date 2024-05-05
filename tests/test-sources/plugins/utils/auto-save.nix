{
  empty = {
    plugins.auto-save.enable = true;
  };

  defaults = {
    plugins.auto-save = {
      enable = true;

      keymaps = {
        silent = true;
        toggle = "<leader>s";
      };
      enableAutoSave = true;
      executionMessage = {
        message.__raw = ''
          function()
            return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
          end
        '';
        dim = 0.18;
        cleaningInterval = 1250;
      };
      triggerEvents = [
        "InsertLeave"
        "TextChanged"
      ];
      condition = ''
        function(buf)
          local fn = vim.fn
          local utils = require("auto-save.utils.data")

          if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
            return true -- met condition(s), can save
          end
          return false -- can't save
        end
      '';
      writeAllBuffers = false;
      debounceDelay = 135;
      callbacks = {
        enabling = null;
        disabling = null;
        beforeAssertingSave = null;
        beforeSaving = null;
        afterSaving = null;
      };
    };
  };
}
