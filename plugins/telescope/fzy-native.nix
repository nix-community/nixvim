{ pkgs, config, lib, ...}:
with lib;
let
  cfg = config.programs.nixvim.plugins.telescope.extensions.fzy-native;
in
{
  options.programs.nixvim.plugins.telescope.extensions.fzy-native = {
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
  in mkIf cfg.enable {
    programs.nixvim.extraPlugins = [ pkgs.vimPlugins.telescope-fzy-native-nvim ];

    programs.nixvim.plugins.telescope.enabledExtensions = [ "fzy_native" ];
    programs.nixvim.plugins.telescope.extensionConfig."fzy_native" = configuration;
  };
}
