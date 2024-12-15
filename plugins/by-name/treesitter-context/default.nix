{
  lib,
  helpers,
  config,
  ...
}:
with lib;
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "treesitter-context";
  packPathName = "nvim-treesitter-context";
  package = "nvim-treesitter-context";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-04-22: remove 2024-06-22
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "maxLines"
    "minWindowHeight"
    "lineNumbers"
    "multilineThreshold"
    "trimScope"
    "mode"
    "separator"
    "zindex"
    "onAttach"
  ];

  settingsOptions = {
    enable = helpers.defaultNullOpts.mkBool true ''
      Enable this plugin (Can be enabled/disabled later via commands)
    '';

    max_lines = helpers.defaultNullOpts.mkUnsignedInt 0 ''
      How many lines the window should span. 0 means no limit.
    '';

    min_window_height = helpers.defaultNullOpts.mkUnsignedInt 0 ''
      Minimum editor window height to enable context. 0 means no limit.
    '';

    line_numbers = helpers.defaultNullOpts.mkBool true ''
      Whether to show line numbers.
    '';

    multiline_threshold = helpers.defaultNullOpts.mkUnsignedInt 20 ''
      Maximum number of lines to collapse for a single context line.
    '';

    trim_scope =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "outer"
          "inner"
        ]
        ''
          Which context lines to discard if `max_lines` is exceeded.
        '';

    mode =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "cursor"
          "topline"
        ]
        ''
          Line used to calculate context.
        '';

    separator = helpers.mkNullOrOption types.str ''
      Separator between context and content.
      Should be a single character string, like "-".
      When separator is set, the context will only show up when there are at least 2 lines above
      cursorline.
    '';

    zindex = helpers.defaultNullOpts.mkUnsignedInt 20 ''
      The Z-index of the context window.
    '';

    on_attach = helpers.defaultNullOpts.mkLuaFn "nil" ''
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
    warnings = mkIf (!config.plugins.treesitter.enable) [
      "Nixvim: treesitter-context needs treesitter to function as intended"
    ];
  };
}
