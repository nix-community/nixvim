{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  helpers = import ../../helpers.nix {inherit lib;};
in {
  options.plugins.treesitter-rainbow =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "treesitter-rainbow";

      package = helpers.mkPackageOption "treesitter-rainbow" pkgs.vimPlugins.nvim-ts-rainbow2;

      disable =
        helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]"
        "List of languages you want to disable the plugin for.";

      query =
        helpers.defaultNullOpts.mkStr "rainbow-parens"
        "The query to use for finding delimiters.";

      strategy =
        helpers.defaultNullOpts.mkStr "require('ts-rainbow').strategy.global"
        "The query to use for finding delimiters. Directly provide lua code.";

      hlgroups =
        helpers.defaultNullOpts.mkNullable (types.listOf types.str)
        ''
          [
            "TSRainbowRed"
            "TSRainbowYellow"
            "TSRainbowBlue"
            "TSRainbowOrange"
            "TSRainbowGreen"
            "TSRainbowViolet"
            "TSRainbowCyan"
          ]
        ''
        "The list of highlight groups to apply.";
    };

  config = let
    cfg = config.plugins.treesitter-rainbow;
  in
    mkIf cfg.enable {
      warnings = mkIf (!config.plugins.treesitter.enable) [
        "Nixvim: treesitter-rainbow needs treesitter to function as intended"
      ];

      extraPlugins = [cfg.package];

      plugins.treesitter.moduleConfig.rainbow =
        {
          enable = true;

          inherit (cfg) disable;
          inherit (cfg) query;
          strategy = helpers.ifNonNull' cfg.strategy (helpers.mkRaw cfg.strategy);
          inherit (cfg) hlgroups;
        }
        // cfg.extraOptions;
    };
}
