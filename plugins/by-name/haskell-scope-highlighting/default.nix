{
  lib,
  helpers,
  config,
  ...
}:
with lib;
lib.nixvim.plugins.mkVimPlugin {
  name = "haskell-scope-highlighting";
  packPathName = "haskell-scope-highlighting.nvim";
  package = "haskell-scope-highlighting-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraConfig = {
    warnings = optional (!config.plugins.treesitter.enable) ''
      Nixvim (plugins.haskell-scope-highlighting): haskell-scope-highlighting needs treesitter to function as intended.
      Please, enable it by setting `plugins.treesitter.enable` to `true`.
    '';
  };
}
