{
  empty = {
    plugins.formatter-nvim.enable = true;
  };

  default = {
    plugins.formatter-nvim = {
      enable = true;
      logging = true;
      logLevel = "WARN";
    };
  };

  example = {
    plugins.formatter-nvim = {
      enable = true;
      logging = true;
      logLevel = "WARN";
      filetype = {
        lua = [
          "lua.stylua"
          {
            __raw = ''
              function()
                if util.get_current_buffer_file_name() == "special.lua" then
                  return nil
                end

                return {
                  exe = "stylua",
                  args = {
                    "--search-parent-directories",
                    "--stdin-filepath",
                    util.escape_path(util.get_current_buffer_file_path()),
                    "--",
                    "-",
                  },
                  stdin = true,
                }
              end
            '';
          }
        ];
        "*" = ["any.remove_trailing_whitespace"];
      };
    };
  };
}
