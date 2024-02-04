{
  lib,
  pkgs,
  helpers,
  config,
  ...
}:
with lib; let
  cfg = config.plugins.haskell-scope-highlighting;
in {
  options.plugins.haskell-scope-highlighting = {
    enable = mkEnableOption "haskell-scope-highlighting";

    package = helpers.mkPackageOption "haskell-scope-highlighting" pkgs.vimPlugins.haskell-scope-highlighting-nvim;
  };

  config = mkIf cfg.enable {
    warnings = optional (!config.plugins.treesitter.enable) ''
      Nixvim (plugins.haskell-scope-highlighting): haskell-scope-highlighting needs treesitter to function as intended. Please, enable it by setting `plugins.treesitter.enable` to `true`.
    '';

    extraPlugins = [cfg.package];
  };
}
