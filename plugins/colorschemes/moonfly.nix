{
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "moonfly";
  colorscheme = "moonfly";
  packPathName = "vim-moonfly-colors";
  package = "vim-moonfly-colors";
  isColorscheme = true;

  maintainers = [ lib.maintainers.AidanWelch ];

  globalPrefix = "moonfly";
  settingsExample = {
    Italics = true;
    NormalFloat = false;
    TerminalColors = true;
    Transparent = false;
    Undercurls = true;
    UnderlineMatchParen = false;
    VirtualTextColor = false;
    WinSeparator = 1;
  };
}
