{
  lib,
  ...
}:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "one";
  isColorscheme = true;
  originalName = "vim-one";
  package = "vim-one";
  globalPrefix = "one_";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    allow_italics = lib.nixvim.defaultNullOpts.mkBool false ''
      Whether to enable _italic_ (as long as your terminal supports it).
    '';
  };

  settingsExample = {
    allow_italics = true;
  };

  extraConfig = cfg: { opts.termguicolors = lib.mkDefault true; };
}
