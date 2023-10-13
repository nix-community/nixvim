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
      enable = mkEnableOption "better-escape.nvim";

      package = helpers.mkPackageOption "better-escape.nvim" pkgs.vimPlugins.better-escape-nvim;

      mapping = helpers.mkNullOrOption (with types; listOf str) ''
        List of mappings to use to enter escape mode.
      '';

      timeout =
        helpers.defaultNullOpts.mkNullable
        (with types;
            either ints.unsigned str)
        "vim.o.timeoutlen" ''
          The time in which the keys must be hit in ms. Use option timeoutlen by default.
        '';

      clearEmptyLines = helpers.defaultNullOpts.mkBool false ''
        Clear line after escaping if there is only whitespace.
      '';

      keys =
        helpers.defaultNullOpts.mkNullable
        (with types;
          either str helpers.rawType
        )
        "<ESC>"
        ''
          Keys used for escaping, if it is a function will use the result everytime.

          Example (recommended):

          keys.__raw = \'\'
            function()
              return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>'
            end
          \'\';
        '';
    };

  config = let
    setupOptions = with cfg;
      {
        inherit mapping keys;
        timeout =
          if isString timeout
          then helpers.mkRaw "timeout"
          else timeout;
        clear_empty_lines = clearEmptyLines;
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require('better_escape').setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
