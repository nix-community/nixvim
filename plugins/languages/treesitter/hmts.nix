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

    package = lib.mkPackageOption pkgs "hmts.nvim" {
      default = [
        "vimPlugins"
        "hmts-nvim"
      ];
    };
  };

  config = mkIf cfg.enable {
    warnings = optional (!config.plugins.treesitter.enable) [
      "Nixvim: hmts needs treesitter to function as intended"
    ];

    extraPlugins = [ cfg.package ];
  };
}
