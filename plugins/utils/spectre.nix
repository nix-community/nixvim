{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; {
  options.plugins.spectre =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "nvim-spectre";

      package = helpers.mkPackageOption "nvim-spectre" pkgs.vimPlugins.nvim-spectre;

      colorDevicon = helpers.defaultNullOpts.mkBool true "If set to true will color devicons";

      openCmd = helpers.defaultNullOpts.mkStr "vnew" "Command to run when opening spectre";

      liveUpdate = helpers.defaultNullOpts.mkBool false "If set to true will auto execute search again when you write to any file in vim";

      lineSepStart = helpers.defaultNullOpts.mkStr "┌-----------------------------------------" "Shown to Separate search and search results";

      resultPadding = helpers.defaultNullOpts.mkStr "¦  " "Shown for padding the result on the left";

      lineSep = helpers.defaultNullOpts.mkStr "└-----------------------------------------" "Shown at the bottom of the search results";
    };

  config = let
    cfg = config.plugins.refactoring;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = let
        opts = with cfg; {
        };
      in ''
        require('spectre').setup(${helpers.toLuaObject opts})
      '';
    };
}
