{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.quickmath;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.quickmath = {
    enable = mkEnableOption "quickmath.nvim";

    package = helpers.mkPackageOption "quickmath.nvim" pkgs.vimPlugins.quickmath-nvim;

    keymap = {
      key = helpers.mkNullOrOption types.str "Keymap to run the `:Quickmath` command.";

      silent = mkOption {
        type = types.bool;
        description = "Whether the quickmath keymap should be silent.";
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];

    maps.normal = mkIf (cfg.keymap.key != null) {
      ${cfg.keymap.key} = {
        action = ":Quickmath<CR>";
        inherit (cfg.keymap) silent;
      };
    };
  };
}
