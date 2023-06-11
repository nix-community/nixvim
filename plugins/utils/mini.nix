{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.mini;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.mini = {
    enable = mkEnableOption "mini.nvim";

    package = helpers.mkPackageOption "mini.nvim" pkgs.vimPlugins.mini-nvim;

    modules = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = ''
        Enable and configure the mini modules.
        The keys are the names of the modules (without the `mini.` prefix).
        The value is an attrs of configuration options for the module.
        Leave the attrs empty to use the module's default configuration.
      '';
      example = {
        ai = {
          n_lines = 50;
          search_method = "cover_or_next";
        };
        surrounds = {};
      };
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];

    extraConfigLua =
      concatLines
      (
        mapAttrsToList
        (
          name: config: "require('mini.${name}').setup(${helpers.toLuaObject config})"
        )
        cfg.modules
      );
  };
}
