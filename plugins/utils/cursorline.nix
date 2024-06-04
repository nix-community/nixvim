{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.cursorline;
in {
  options.plugins.cursorline =
    helpers.neovim-plugin.extraOptionsOptions
    // {
      enable = mkEnableOption "nvim-cursorline";

      package = helpers.mkPluginPackageOption "nvim-cursorline" pkgs.vimPlugins.nvim-cursorline;

      cursorline = {
        enable = helpers.defaultNullOpts.mkBool true "Show / hide cursorline in connection with cursor moving.";

        timeout = helpers.defaultNullOpts.mkInt 1000 "Time (in ms) after which the cursorline appears.";

        number = helpers.defaultNullOpts.mkBool false "Whether to also highlight the line number.";
      };
      cursorword = {
        enable = helpers.defaultNullOpts.mkBool true "Underlines the word under the cursor.";

        minLength = helpers.defaultNullOpts.mkInt 3 "Minimum length for underlined words.";

        hl =
          helpers.defaultNullOpts.mkNullable types.attrs "{underline = true;}"
          "Highliht definition map for cursorword highlighting.";
      };
    };

  config = let
    options =
      {
        cursorline = with cfg.cursorline; {
          inherit enable timeout number;
        };
        cursorword = with cfg.cursorword; {
          inherit enable;
          min_length = minLength;
          inherit hl;
        };
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require('nvim-cursorline').setup(${helpers.toLuaObject options})
      '';
    };
}
