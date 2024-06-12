{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "one";
  isColorscheme = true;
  originalName = "vim-one";
  defaultPackage = pkgs.vimPlugins.vim-one;
  globalPrefix = "one_";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    allow_italics = helpers.defaultNullOpts.mkBool false ''
      Whether to enable _italic_ (as long as your terminal supports it).
    '';
  };

  settingsExample = {
    allow_italics = true;
  };

  extraConfig = cfg: { opts.termguicolors = lib.mkDefault true; };
}
