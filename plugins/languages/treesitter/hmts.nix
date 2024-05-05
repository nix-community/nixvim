{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.hmts;
in
{
  meta.maintainers = [ maintainers.GaetanLepage ];

  options.plugins.hmts = {
    enable = mkEnableOption "hmts.nvim";

    package = helpers.mkPackageOption "hmts.nvim" pkgs.vimPlugins.hmts-nvim;
  };

  config = mkIf cfg.enable {
    warnings = optional (!config.plugins.treesitter.enable) [
      "Nixvim: treesitter-refactor needs treesitter to function as intended"
    ];

    extraPlugins = [ cfg.package ];
  };
}
