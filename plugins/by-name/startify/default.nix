{
  lib,
  helpers,
  ...
}:
with lib;
with lib.nixvim.plugins;
mkVimPlugin {
  name = "startify";
  package = "vim-startify";
  globalPrefix = "startify_";
  description = "The fancy start screen for Vim.";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-03-01: remove 2024-05-01
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [
    "sessionDir"
    "lists"
    "bookmarks"
    "commands"
    "filesNumber"
    "sessionAutoload"
    "sessionBeforeSave"
    "sessionPersistence"
    "sessionDeleteBuffers"
    "changeToDir"
    "changeToVcsRoot"
    "changeCmd"
    "paddingLeft"
    "enableSpecial"
    "enableUnsafe"
    "sessionRemoveLines"
    "sessionNumber"
    "sessionSort"
    "customIndices"
    "customHeader"
    "customFooter"
    "relativePath"
    "useEnv"
    {
      old = "updateOldFiles";
      new = "update_oldfiles";
    }
    {
      old = "skipList";
      new = "skiplist";
    }
    {
      old = "useUnicode";
      new = "fortune_use_unicode";
    }
    {
      old = "skipListServer";
      new = "skiplist_server";
    }
    {
      old = "sessionSaveVars";
      new = "session_savevars";
    }
    {
      old = "sessionCmds";
      new = "session_savecmds";
    }
    {
      old = "customQuotes";
      new = "custom_header_quotes";
    }
    {
      old = "disableAtVimEnter";
      new = "disable_at_vimenter";
    }
  ];

  settingsOptions = import ./settings-options.nix { inherit lib helpers; };

  # TODO
  settingsExample = {
    custom_header = [
      ""
      "     ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
      "     ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
      "     ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
      "     ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
      "     ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
      "     ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
    ];
    change_to_dir = false;
    fortune_use_unicode = true;
  };
}
