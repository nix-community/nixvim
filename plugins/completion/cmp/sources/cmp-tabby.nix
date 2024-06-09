{
  lib,
  helpers,
  config,
  ...
}:
with lib;
let
  cfg = config.plugins.cmp-tabby;
in
{
  meta.maintainers = [ maintainers.GaetanLepage ];

  options.plugins.cmp-tabby = helpers.neovim-plugin.extraOptionsOptions // {
    host = helpers.defaultNullOpts.mkStr "http://localhost:5000" ''
      The address of the tabby host server.
    '';

    maxLines = helpers.defaultNullOpts.mkUnsignedInt 100 ''
      The max number of lines to complete.
    '';

    runOnEveryKeyStroke = helpers.defaultNullOpts.mkBool true ''
      Whether to run the completion on every keystroke.
    '';

    stop = helpers.defaultNullOpts.mkListOf types.str [ "\n" ] "";
  };

  config = mkIf cfg.enable {
    extraConfigLua =
      let
        setupOptions =
          with cfg;
          {
            inherit host;
            max_lines = maxLines;
            run_on_every_keystroke = runOnEveryKeyStroke;
            inherit stop;
          }
          // cfg.extraOptions;
      in
      ''
        require('cmp_tabby.config'):setup(${helpers.toLuaObject setupOptions})
      '';
  };
}
