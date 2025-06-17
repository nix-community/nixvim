{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "vimwiki";
  globalPrefix = "vimwiki_";
  description = "Personal Wiki for Vim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    global_ext = 0;
    use_calendar = 1;
    hl_headers = 1;
    hl_cb_checked = 1;
    autowriteall = 0;
    listsym_rejected = "✗";
    listsyms = "○◐●✓";
    list = [
      {
        path = "~/docs/notes/";
        syntax = "markdown";
        ext = ".md";
      }
    ];
    key_mappings = {
      all_maps = 1;
      global = 1;
      headers = 1;
    };
  };
}
