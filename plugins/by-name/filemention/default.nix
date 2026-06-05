{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "filemention";
  package = "filemention-nvim";
  description = "A Neovim plugin for file selection";

  imports = [
    { cmpSourcePlugins.filemention = "filemention"; }
  ];

  maintainers = [ lib.maintainers.ZainKergaye ];

  settingsExample = {
    trigger = "@";
    root = "git";
    respect_gitignore = true;
    include_hidden = false;
    format = "bare";
    filetypes = [
      "markdown"
      "text"
      "gitcommit"
    ];
    max_items = 500;
    finder = "auto";
  };
}
