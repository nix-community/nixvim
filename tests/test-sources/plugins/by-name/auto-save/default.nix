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
        trigger_events = {
          immediate_save = [
            "BufLeave"
            "FocusLost"
          ];
          defer_save = [
            "InsertLeave"
            "TextChanged"
          ];
          cancel_deferred_save = [ "InsertEnter" ];
        };
        condition.__raw = "nil";
        write_all_buffers = false;
        noautocmd = false;
        lockmarks = false;
        debounce_delay = 1000;
        debug = false;
      };
    };
  };
}
