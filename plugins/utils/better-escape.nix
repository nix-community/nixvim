{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.better-escape;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.better-escape =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "better-escape";

      package = helpers.mkPackageOption "better-escape" pkgs.vimPlugins.better-escape-nvim;

      mapping = helpers.mkNullOrOption (with types; listOf str) ''
        List of mappings to use to enter escape mode.
      '';

      timeout = helpers.defaultNullOpts.mkInt 100 ''
        The time in which the keys must be hit in ms. Use option timeoutlen by default.
      '';

      clearEmptyLines = helpers.defaultNullOpts.mkBool false ''
        Clear line after escaping if there is only whitespace.
      '';

      keys =
        helpers.defaultNullOpts.mkNullable
        (with types;
            either str helpers.rawType)
        "<ESC>"
        ''
          Keys used for escaping, if it is a function will use the result everytime.

          example(recommended):

          keys = {
          	_raw = \'\'
          		function()
          			return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>'
          		 end,.
          		 \'\'
          	};
        '';
    };

  config = let
    setupOptions = with cfg;
      {
        inherit mappings timeout keys;
        clear_empty_lines = clearEmptyLines;
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require('better-escape').setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
