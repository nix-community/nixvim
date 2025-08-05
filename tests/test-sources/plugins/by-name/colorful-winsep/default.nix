{
  empty = {
    plugins.colorful-winsep.enable = true;
  };

  defaults = {
    plugins.colorful-winsep = {
      enable = true;
      settings = {
        symbols = [
          "━"
          "┃"
          "┏"
          "┓"
          "┗"
          "┛"
        ];
        no_exec_files = [
          "packer"
          "TelescopePrompt"
          "mason"
          "CompetiTest"
        ];
        hi = {
          fg = "#957CC6";
          bg.__raw = ''vim.api.nvim_get_hl_by_name("Normal", true)["background"]'';
        };
        events = [
          "WinEnter"
          "WinResized"
          "SessionLoadPost"
        ];
        smooth = true;
        exponential_smoothing = true;
        only_line_seq = true;
        anchor = {
          left = {
            height = 1;
            x = -1;
            y = -1;
          };
          right = {
            height = 1;
            x = -1;
            y = 0;
          };
          up = {
            width = 0;
            x = -1;
            y = 0;
          };
          bottom = {
            width = 0;
            x = 1;
            y = 0;
          };
        };
        light_pollution.__raw = "function(lines) end";
      };
    };
  };

  example = {
    plugins.colorful-winsep = {
      enable = true;
      settings = {
        hi = {
          bg = "#7d8618";
          fg = "#b8bb26";
        };
        only_line_seq = true;
        no_exec_files = [
          "packer"
          "TelescopePrompt"
          "mason"
          "CompetiTest"
          "NvimTree"
        ];
        symbols = [
          "━"
          "┃"
          "┏"
          "┓"
          "┗"
          "┛"
        ];
      };
    };
  };
}
