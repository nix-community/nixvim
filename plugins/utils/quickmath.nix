{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.quickmath;
in
{
  options.plugins.quickmath = {
    enable = mkEnableOption "quickmath.nvim";

    package = helpers.mkPluginPackageOption "quickmath.nvim" pkgs.vimPlugins.quickmath-nvim;

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
    extraPlugins = [ cfg.package ];

    keymaps =
      with cfg.keymap;
      optional (key != null) {
        mode = "n";
        inherit key;
        action = ":Quickmath<CR>";
        options.silent = cfg.keymap.silent;
      };
  };
}
