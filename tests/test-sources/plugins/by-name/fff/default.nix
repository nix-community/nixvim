{ lib }:
{
  empty = {
    plugins.fff.enable = true;
  };

  example = {
    plugins.fff = {
      enable = true;

      settings = {
        base_path = lib.nixvim.mkRaw "vim.fn.getcwd()";
        max_results = 100;
        layout = {
          height = 0.8;
          width = 0.8;
          preview_position = "right";
        };
        key_bindings = {
          close = [
            "<Esc>"
            "<C-c>"
          ];
          select_file = "<CR>";
          open_split = "<C-s>";
          open_vsplit = "<C-v>";
          open_tab = "<C-t>";
          move_up = [
            "<Up>"
            "<C-p>"
          ];
          move_down = [
            "<Down>"
            "<C-n>"
          ];
        };

      };
    };
  };

  defaults = {
    plugins.fff = {
      enable = true;

      settings = {
        base_path = lib.nixvim.mkRaw "vim.fn.getcwd()";
        prompt = "🪿 ";
        title = "FFFiles";
        max_results = 100;
        max_threads = 4;
        lazy_sync = true;
        layout = {
          height = 0.8;
          width = 0.8;
          prompt_position = "bottom";
          preview_position = "right";
          preview_size = 0.5;
        };
        preview = {
          enabled = true;
          max_size = lib.nixvim.mkRaw "10 * 1024 * 1024";
          chunk_size = 8192;
          binary_file_threshold = 1024;
          imagemagick_info_format_str = "%m: %wx%h, %[colorspace], %q-bit";
          line_numbers = false;
          wrap_lines = false;
          show_file_info = true;
          filetypes = {
            svg.wrap_lines = true;
            markdown.wrap_lines = true;
            text.wrap_lines = true;
          };
        };
        keymaps = {
          close = "<Esc>";
          select = "<CR>";
          select_split = "<C-s>";
          select_vsplit = "<C-v>";
          select_tab = "<C-t>";
          move_up = [
            "<Up>"
            "<C-p>"
          ];
          move_down = [
            "<Down>"
            "<C-n>"
          ];
          preview_scroll_up = "<C-u>";
          preview_scroll_down = "<C-d>";
          toggle_debug = "<F2>";
        };
        hl = {
          border = "FloatBorder";
          normal = "Normal";
          cursor = "CursorLine";
          matched = "IncSearch";
          title = "Title";
          prompt = "Question";
          active_file = "Visual";
          frecency = "Number";
          debug = "Comment";
        };
        frecency = {
          enabled = true;
          db_path = lib.nixvim.mkRaw "vim.fn.stdpath('cache') .. '/fff_nvim'";
        };
        debug = {
          enabled = false;
          show_scores = false;
        };
        logging = {
          enabled = true;
          log_file = lib.nixvim.mkRaw "vim.fn.stdpath('log') .. '/fff.log'";
          log_level = "info";
        };
      };
    };
  };
}
