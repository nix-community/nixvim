{
  config,
  lib,
  pkgs,
  ...
} @ args: let
  defs = import ../plugin-defs.nix {inherit pkgs;};
  helpers = import ../helpers.nix args;
in
  with lib; {
    options.plugins.netman = {
      enable = mkEnableOption "netman.nvim, a framework to access remote resources";
      package = helpers.mkPackageOption "netman.nvim" defs.netman-nvim;

      neoTreeIntegration = mkEnableOption "support for netman as a neo-tree source";
    };

    config = let
      cfg = config.plugins.netman;
    in
      mkIf cfg.enable {
        extraPlugins = [cfg.package];
        extraConfigLua = ''
          require("netman")
        '';

        plugins.neo-tree.extraSources = mkIf cfg.neoTreeIntegration ["netman.ui.neo-tree"];
      };
  }
