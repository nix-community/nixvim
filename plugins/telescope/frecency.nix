{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.plugins.telescope.extensions.frecency;
in
{
  options.plugins.telescope.extensions.frecency = {
    enable = mkEnableOption "frecency";

    package = mkOption {
      type = types.package;
      default = pkgs.vimPlugins.telescope-frecency-nvim;
      description = "Plugin to use for telescope frecency";
    };

    dbRoot = mkOption {
      type = types.nullOr types.str;
      description = "Path to parent directory of custom database location. Defaults to $XDG_DATA_HOME/nvim";
      default = null;
    };
    defaultWorkspace = mkOption {
      type = types.nullOr types.str;
      description = "Default workspace tag to filter by e.g 'CWD' to filter by default to the current directory";
      default = null;
    };
    ignorePatterns = mkOption {
      type = types.nullOr (types.listOf types.str);
      description = "Patterns in this list control which files are indexed";
      default = null;
    };
    showScores = mkOption {
      type = types.nullOr types.bool;
      description = "Whether to show scores generated by the algorithm in the results";
      default = null;
    };
    workspaces = mkOption {
      type = types.nullOr (types.attrsOf types.str);
      description = "this table contains mappings of workspace_tag -> workspace_directory";
      default = null;
    };
    showUnindexed = mkOption {
      type = types.nullOr types.bool;
      description = "Determines if non-indexed files are included in workspace filter results";
      default = null;
    };
    deviconsDisabled = mkOption {
      type = types.nullOr types.bool;
      description = "Disable devicons (if available)";
      default = null;
    };
  };

  config =
    let
      configuration = {
        db_root = cfg.dbRoot;
        default_workspace = cfg.defaultWorkspace;
        ignore_patterns = cfg.ignorePatterns;
        show_scores = cfg.showScores;
        workspaces = cfg.workspaces;
        show_unindexed = cfg.showUnindexed;
        devicons_disabled = cfg.deviconsDisabled;
      };
    in
    mkIf cfg.enable {
      extraPackages = [ pkgs.sqlite ];
      extraPlugins = with pkgs.vimPlugins; [
        cfg.package
        sqlite-lua
      ];

      plugins.telescope.enabledExtensions = [ "frecency" ];
      plugins.telescope.extensionConfig."frecency" = configuration;
    };
}
