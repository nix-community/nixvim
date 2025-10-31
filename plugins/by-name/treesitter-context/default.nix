{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "treesitter-context";
  package = "nvim-treesitter-context";
  description = "Show code context.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    on_attach = lib.nixvim.defaultNullOpts.mkLuaFn "nil" ''
      The implementation of a lua function which takes an integer `buf` as parameter and returns a
      boolean.
      Return `false` to disable attaching.
    '';
  };

  settingsExample = {
    max_lines = 0;
    min_window_height = 0;
    line_numbers = true;
    multiline_threshold = 20;
    trim_scope = "inner";
    mode = "topline";
    separator = "-";
    zindex = 20;
  };

  extraConfig = {
    warnings = lib.nixvim.mkWarnings "plugins.treesitter-context" {
      when = !config.plugins.treesitter.enable;
      message = "This plugin needs treesitter to function as intended.";
    };
  };
}
