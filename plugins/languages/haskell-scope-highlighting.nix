{
  lib,
  helpers,
  config,
  ...
}:
with lib;
helpers.vim-plugin.mkVimPlugin {
  name = "haskell-scope-highlighting";
  originalName = "haskell-scope-highlighting.nvim";
  package = "haskell-scope-highlighting-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraConfig = _: {
    warnings = optional (!config.plugins.treesitter.enable) ''
      Nixvim (plugins.haskell-scope-highlighting): haskell-scope-highlighting needs treesitter to function as intended.
      Please, enable it by setting `plugins.treesitter.enable` to `true`.
    '';
  };
}
