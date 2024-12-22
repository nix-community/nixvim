{
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "one";
  isColorscheme = true;
  packPathName = "vim-one";
  package = "vim-one";
  globalPrefix = "one_";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    allow_italics = lib.nixvim.defaultNullOpts.mkFlagInt 0 ''
      Whether to enable _italic_ (as long as your terminal supports it).
    '';
  };

  settingsExample = {
    allow_italics = true;
  };

  extraConfig = {
    opts.termguicolors = lib.mkDefault true;
  };
}
