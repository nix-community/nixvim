{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.telescope.extensions.fzf-native;
in {
  options.plugins.telescope.extensions.fzf-native = {
    enable = mkEnableOption "fzf-native";

    package = helpers.mkPackageOption "telescope extension fzf-native" pkgs.vimPlugins.telescope-fzf-native-nvim;

    fuzzy = mkOption {
      type = types.nullOr types.bool;
      description = "Whether to fuzzy search. False will do exact matching";
      default = null;
    };
    overrideGenericSorter = mkOption {
      type = types.nullOr types.bool;
      description = "Override the generice sorter";
      default = null;
    };
    overrideFileSorter = mkOption {
      type = types.nullOr types.bool;
      description = "Override the file sorter";
      default = null;
    };
    caseMode = mkOption {
      type = types.nullOr (types.enum ["smart_case" "ignore_case" "respect_case"]);
      default = null;
    };
  };

  config = let
    configuration = {
      inherit (cfg) fuzzy;
      override_generic_sorter = cfg.overrideGenericSorter;
      override_file_sorter = cfg.overrideFileSorter;
      case_mode = cfg.caseMode;
    };
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      plugins.telescope.enabledExtensions = ["fzf"];
      plugins.telescope.extensionConfig."fzf" = configuration;
    };
}
