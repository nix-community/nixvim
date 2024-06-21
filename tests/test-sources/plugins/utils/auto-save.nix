{
  empty = {
    plugins.auto-save.enable = true;
  };

  example = {
    plugins.auto-save = {
      enable = true;

      settings = {
        condition = ''
          function(buf)
            local fn = vim.fn
            local utils = require("auto-save.utils.data")

            if utils.not_in(fn.getbufvar(buf, "&filetype"), {'oil'}) then
              return true
            end
            return false
          end
        '';
        write_all_buffers = true;
        debounce_delay = 1000;
      };
    };
  };

  defaults = {
    plugins.auto-save = {
      enable = true;

      settings = {
        enabled = true;
        execution_message = {
          enabled = true;
          dim = 0.18;
          cleaning_interval = 1250;
          message.__raw = ''
            function()
              return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
            end
          '';
        };
        trigger_events = {
          immediate_save = [
            "BufLeave"
            "FocusLost"
          ];
          defer_save = [
            "InsertLeave"
            "TextChanged"
          ];
          cancel_defered_save = [ "InsertEnter" ];
        };
        condition = null;
        write_all_buffers = false;
        noautocmd = false;
        lockmarks = false;
        debounce_delay = 1000;
        debug = false;
      };
    };
  };
}
