{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.telescope.extensions.fzy-native;
in {
  options.plugins.telescope.extensions.fzy-native = {
    enable = mkEnableOption "Enable fzy-native";

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
  };

  config = let
    configuration = {
      override_generic_sorter = cfg.overrideGenericSorter;
      override_file_sorter = cfg.overrideFileSorter;
    };
  in
    mkIf cfg.enable {
      extraPlugins = [pkgs.vimPlugins.telescope-fzy-native-nvim];

      plugins.telescope.enabledExtensions = ["fzy_native"];
      plugins.telescope.extensionConfig."fzy_native" = configuration;
    };
}
