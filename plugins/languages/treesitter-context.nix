{ pkgs
, lib
, config
, helpers
, ...
}:
with lib; {
  options.plugins.treesitter-context = {
    enable = mkEnableOption "nvim-treesitter-context";

    package = helpers.mkPackageOption "treesitter-context" pkgs.vimPlugins.nvim-treesitter-context;

    maxLines = mkOption {
      type = types.nullOr types.ints.positive;
      default = null;
      description = "How many lines the window should span. Null means no limit";
    };

    trimScope = mkOption {
      type = types.enum [ "outer" "inner" ];
      default = "outer";
      description = "Which context lines to discard if `max_lines` is exceeded";
    };

    maxWindowHeight = mkOption {
      type = types.nullOr types.ints.positive;
      default = null;
      description = "Minimum editor window height to enable context";
    };

    patterns = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = { };
      description = ''
        Patterns to use for context delimitation. The 'default' key matches all filetypes
      '';
    };

    exactPatterns = mkOption {
      type = types.attrsOf types.bool;
      default = { };
      description = "Treat the coresponding entry in patterns as an exact match";
    };
  };

  config =
    let
      cfg = config.plugins.treesitter-context;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      plugins.treesitter.moduleConfig.context = {
        max_lines = cfg.maxLines;
        trim_scope = cfg.trimScope;
        min_window_height = cfg.maxWindowHeight;
      };
    };
}
