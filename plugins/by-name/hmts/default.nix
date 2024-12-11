{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.plugins.hmts;
in
{
  meta.maintainers = [ lib.maintainers.GaetanLepage ];

  options.plugins.hmts = {
    enable = lib.mkEnableOption "hmts.nvim";

    package = lib.mkPackageOption pkgs "hmts.nvim" {
      default = [
        "vimPlugins"
        "hmts-nvim"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.optional (
      !config.plugins.treesitter.enable
    ) "Nixvim: hmts needs treesitter to function as intended";

    extraPlugins = [ cfg.package ];
  };
}
