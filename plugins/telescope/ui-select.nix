{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.telescope.extensions.ui-select;
in {
  options.plugins.telescope.extensions.ui-select = {
    enable = mkEnableOption "ui-select extension for telescope";

    package = helpers.mkPackageOption "telescope extension ui-select" pkgs.vimPlugins.telescope-ui-select-nvim;

    settings = mkOption {
      type = with types; attrsOf anything;
      default = {};
      example = {
        specific_opts.codeactions = false;
      };
      description = "Settings for this extension.";
    };
  };

  config = mkIf cfg.enable {
    plugins.telescope = {
      enabledExtensions = ["ui-select"];
      settings.extensions.ui-select = cfg.settings;
    };

    extraPlugins = [cfg.package];
  };
}
