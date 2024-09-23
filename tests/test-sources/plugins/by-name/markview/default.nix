{
  empty = {
    plugins.markview.enable = true;
  };

  defaults = {
    plugins.markview = {
      enable = true;

      settings = {
        buf_ignore = [ "nofile" ];
        modes = [
          "n"
          "no"
        ];
        hybrid_modes = [ ];
        callback = {
          on_enable = # Lua
            ''
              function(buf, win)
                vim.wo[window].conceallevel = 2;
                vim.wo[window].concealcursor = "nc";
              end
            '';
          on_disable = # Lua
            ''
              function(buf, win)
                  vim.wo[window].conceallevel = 0;
                  vim.wo[window].concealcursor = "";
              end
            '';
          on_mode_change = # Lua
            ''
              function(buf, win, mode)
                if vim.list_contains(markview.configuration.modes, mode) then
                  vim.wo[window].conceallevel = 2;
                else
                  vim.wo[window].conceallevel = 0;
                end
              end
            '';
        };
      };
    };
  };
}
