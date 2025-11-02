{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-pick";
  moduleName = "mini.pick";

  dependencies = [ "ripgrep" ];

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    delay = {
      async = 10;
      busy = 50;
    };

    mappings = {
      caret_left = "<Left>";
      caret_right = "<Right>";
      choose = "<CR>";
      choose_in_split = "<C-s>";
      choose_in_tabpage = "<C-t>";
      choose_in_vsplit = "<C-v>";
      choose_marked = "<M-CR>";
      delete_char = "<BS>";
      delete_char_right = "<Del>";
      delete_left = "<C-u>";
      delete_word = "<C-w>";
      mark = "<C-x>";
      mark_all = "<C-a>";
      move_down = "<C-n>";
      move_start = "<C-g>";
      move_up = "<C-p>";
      paste = "<C-r>";
      refine = "<C-Space>";
      refine_marked = "<M-Space>";
      scroll_down = "<C-f>";
      scroll_left = "<C-h>";
      scroll_right = "<C-l>";
      scroll_up = "<C-b>";
      stop = "<Esc>";
      toggle_info = "<S-Tab>";
      toggle_preview = "<Tab>";
    };

    options = {
      content_from_bottom = false;
      use_cache = false;
    };

    source = {
      items = lib.nixvim.nestedLiteralLua "nil";
      name = lib.nixvim.nestedLiteralLua "nil";
      cwd = lib.nixvim.nestedLiteralLua "nil";
      match = lib.nixvim.nestedLiteralLua "nil";
      show = lib.nixvim.nestedLiteralLua "nil";
      preview = lib.nixvim.nestedLiteralLua "nil";
      choose = lib.nixvim.nestedLiteralLua "nil";
      choose_marked = lib.nixvim.nestedLiteralLua "nil";
    };

    window = {
      config = lib.nixvim.nestedLiteralLua "nil";
      prompt_caret = "▏";
      prompt_prefix = "> ";
    };
  };
}
