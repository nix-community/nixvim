let
  mkExtension = import ./_mk-extension.nix;
in
mkExtension {
  name = "history";
  extensionName = "history";
  package = "codecompanion-history-nvim";

  settingsExample = {
    keymap = "gh";
    auto_generate_title = true;
    continue_last_chat = false;
    delete_on_clearing_chat = false;
    picker = "telescope";
    enable_logging = false;
    dir_to_save.__raw = "vim.fn.stdpath('data') .. '/codecompanion-history'";
  };
}
