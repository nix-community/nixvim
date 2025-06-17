{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "haskell-scope-highlighting";
  packPathName = "haskell-scope-highlighting.nvim";
  package = "haskell-scope-highlighting-nvim";
  description = "Haskell syntax highlighting that considers variable scopes.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraConfig = {
    warnings = lib.nixvim.mkWarnings "plugins.haskell-scope-highlighting" {
      when = !config.plugins.treesitter.enable;
      message = ''
        haskell-scope-highlighting needs treesitter to function as intended.
        Please, enable it by setting `plugins.treesitter.enable` to `true`.
      '';
    };
  };
}
