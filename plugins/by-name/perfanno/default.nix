{ lib, ... }:

lib.nixvim.plugins.mkNeovimPlugin {
  name = "perfanno";
  packPathName = "perfanno.nvim";
  package = "perfanno-nvim";
  description = "NeoVim lua plugin that annotates source code with profiling information from perf, LuaJIT, or other profilers.";

  maintainers = [ lib.maintainers.fredeb ];

  settingsExample = {
    line_highlights.__raw = ''util.make_bg_highlights(nil, "#CC3300", 10)'';
    vt_highlight.__raw = ''util.make_fg_highlight("#CC3300")'';
    formats = [
      {
        percent = true;
        format = "%.2f%%";
        minimum = 0.5;
      }
      {
        percent = false;
        format = "%d";
        minimum = 1;
      }
    ];

    annotate_after_load = true;
    annotate_on_open = true;
    telescope = {
      enabled.__raw = ''pcall(require, "telescope")'';
      annotate = true;
    };

    ts_function_patterns = {
      default = [
        "function"
        "method"
      ];
    };
  };
}
