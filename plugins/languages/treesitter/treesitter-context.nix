{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.treesitter-context;
in {
  # Those warnings were introduced on 08/25/2023. TODO: remove them in October 2023.
  imports = let
    basePluginPath = ["plugins" "treesitter-context"];
  in [
    (
      mkRenamedOptionModule
      (basePluginPath ++ ["maxWindowHeight"])
      (basePluginPath ++ ["minWindowHeight"])
    )
    (
      mkRemovedOptionModule (basePluginPath ++ ["patterns"]) ""
    )
    (
      mkRemovedOptionModule (basePluginPath ++ ["extractPatterns"]) ""
    )
  ];
  options.plugins.treesitter-context =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "nvim-treesitter-context";

      package = helpers.mkPackageOption "nvim-treesitter-context" pkgs.vimPlugins.nvim-treesitter-context;

      maxLines = helpers.defaultNullOpts.mkUnsignedInt 0 ''
        How many lines the window should span. 0 means no limit.
      '';

      minWindowHeight = helpers.defaultNullOpts.mkUnsignedInt 0 ''
        Minimum editor window height to enable context. 0 means no limit.
      '';

      lineNumbers = helpers.defaultNullOpts.mkBool true ''
        Whether to show line numbers.
      '';

      multilineThreshold = helpers.defaultNullOpts.mkUnsignedInt 20 ''
        Maximum number of lines to collapse for a single context line.
      '';

      trimScope = helpers.defaultNullOpts.mkEnumFirstDefault ["outer" "inner"] ''
        Which context lines to discard if `maxLines` is exceeded.
      '';

      mode = helpers.defaultNullOpts.mkEnumFirstDefault ["cursor" "topline"] ''
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

      onAttach = helpers.mkNullOrOption types.str ''
        The implementation of a lua function which takes an integer `buf` as parameter and returns a
        boolean.
        Return `false` to disable attaching.
      '';
    };

  config = let
    setupOptions = with cfg;
      {
        max_lines = maxLines;
        min_window_height = minWindowHeight;
        line_numbers = lineNumbers;
        multiline_threshold = multilineThreshold;
        trim_scope = trimScope;
        inherit
          mode
          separator
          zindex
          ;
        on_attach = helpers.mkRaw onAttach;
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      warnings = mkIf (!config.plugins.treesitter.enable) [
        "Nixvim: treesitter-context needs treesitter to function as intended"
      ];

      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require('treesitter-context').setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
