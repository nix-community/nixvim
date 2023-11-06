{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; {
  options.plugins.ts-context-commentstring =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "nvim-ts-context-commentstring";

      package =
        helpers.mkPackageOption
        "ts-context-commentstring"
        pkgs.vimPlugins.nvim-ts-context-commentstring;
    };

  config = let
    cfg = config.plugins.ts-context-commentstring;
  in
    mkIf cfg.enable {
      warnings = mkIf (!config.plugins.treesitter.enable) [
        "Nixvim: ts-context-commentstring needs treesitter to function as intended"
      ];

      extraPlugins = [cfg.package];

      plugins.treesitter.moduleConfig.context_commentstring =
        {
          enable = true;
        }
        // cfg.extraOptions;
    };
}
