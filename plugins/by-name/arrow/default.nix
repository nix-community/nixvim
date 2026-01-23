{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "arrow";
  package = "arrow-nvim";
  description = "A Neovim plugin to bookmark and navigate through files.";

  maintainers = [ lib.maintainers.hmajid2301 ];

  settingsOptions = {
    show_icons = lib.nixvim.defaultNullOpts.mkBool false ''
      If true will show icons.
    '';

    always_show_path = lib.nixvim.defaultNullOpts.mkBool false ''
      If true will show path.
    '';

    separate_by_branch = lib.nixvim.defaultNullOpts.mkBool false ''
      If true will split bookmarks by git branch.
    '';

    hide_handbook = lib.nixvim.defaultNullOpts.mkBool false ''
      If true to hide the shortcuts on menu.
    '';

    save_path = lib.nixvim.defaultNullOpts.mkLuaFn ''
      function()
        return vim.fn.stdpath("cache") .. "/arrow"
      end
    '' "Function used to determine where to save arrow data.";

    mapping = {
      edit = lib.nixvim.defaultNullOpts.mkStr "e" ''
        Mapping to edit bookmarks.
      '';

      delete_mode = lib.nixvim.defaultNullOpts.mkStr "d" ''
        Mapping to go to delete mode, where you can remove bookmarks.
      '';

      clear_all_items = lib.nixvim.defaultNullOpts.mkStr "C" ''
        Mapping to clear all bookmarks.
      '';

      toggle = lib.nixvim.defaultNullOpts.mkStr "s" ''
        Mapping to save if `separate_save_and_remove` is true.
      '';

      open_vertical = lib.nixvim.defaultNullOpts.mkStr "v" ''
        Mapping to open bookmarks in vertical split.
      '';

      open_horizontal = lib.nixvim.defaultNullOpts.mkStr "-" ''
        Mapping to open bookmarks in horizontal split.
      '';

      quit = lib.nixvim.defaultNullOpts.mkStr "q" ''
        Mapping to quit arrow.
      '';

      remove = lib.nixvim.defaultNullOpts.mkStr "x" ''
        Mapping to remove bookmarks. Only used if `separate_save_and_remove` is true.
      '';

      next_item = lib.nixvim.defaultNullOpts.mkStr "]" ''
        Mapping to go to next bookmark.
      '';

      prev_item = lib.nixvim.defaultNullOpts.mkStr "[" ''
        Mapping to go to previous bookmark.
      '';
    };

    custom_actions = {
      open =
        lib.nixvim.defaultNullOpts.mkLuaFn
          ''
            function(target_file_name, current_file_name) end
          ''
          ''
            - `target_file_name`: file selected to be open
            - `current_file_name`: filename from where this was called
          '';

      split_vertical = lib.nixvim.defaultNullOpts.mkLuaFn ''
        function(target_file_name, current_file_name) end
      '' "";

      split_horizontal = lib.nixvim.defaultNullOpts.mkLuaFn ''
        function(target_file_name, current_file_name) end
      '' "";
    };

    window =
      lib.nixvim.defaultNullOpts.mkAttrsOf lib.types.anything
        {
          relative = "editor";
          width = "auto";
          height = "auto";
          row = "auto";
          col = "auto";
          style = "minimal";
          border = "single";
        }
        ''
          Controls the appearance and position of an arrow window.
          See `:h nvim_open_win()` for all options.
        '';

    per_buffer_config = {
      lines = lib.nixvim.defaultNullOpts.mkInt 4 ''
        Number of lines on preview.
      '';

      sort_automatically = lib.nixvim.defaultNullOpts.mkBool true ''
        If true will sort buffer marks automatically.
      '';

      satellite = {
        enable = lib.nixvim.defaultNullOpts.mkBool false ''
          If true will display arrow index in scrollbar at every update.
        '';

        overlap = lib.nixvim.defaultNullOpts.mkBool false "";

        priority = lib.nixvim.defaultNullOpts.mkInt 1000 "";
      };

      zindex = lib.nixvim.defaultNullOpts.mkInt 50 ''
        Z index of the buffer.
      '';
    };

    separate_save_and_remove = lib.nixvim.defaultNullOpts.mkBool false ''
      If true will remove the toggle and create the save/remove keymaps.
    '';

    leader_key = lib.nixvim.defaultNullOpts.mkStr ";" ''
      The leader key to use for arrow. Will precede all mappings.
      Recommended to be a single character.
    '';

    save_key = lib.nixvim.defaultNullOpts.mkStr "cwd" ''
      What will be used as root to save the bookmarks. Can be also `git_root`.
    '';

    global_bookmarks = lib.nixvim.defaultNullOpts.mkBool false ''
      If true arrow will save files globally (ignores `separate_by_branch`).
    '';

    index_keys = lib.nixvim.defaultNullOpts.mkStr "123456789zxcbnmZXVBNM,afghjklAFGHJKLwrtyuiopWRTYUIOP" ''
      Keys mapped to bookmark index.
    '';

    full_path_list = lib.nixvim.defaultNullOpts.mkListOf lib.types.str [ "update_stuff" ] ''
      Filenames on this list will ALWAYS show the file path too
    '';
  };

  settingsExample = {
    show_icons = true;
    always_show_path = false;
    separate_by_branch = false;
    hide_handbook = false;
    save_path = ''
      function()
          return vim.fn.stdpath("cache") .. "/arrow"
      end
    '';
    mappings = {
      edit = "e";
      delete_mode = "d";
      clear_all_items = "C";
      toggle = "s";
      open_vertical = "v";
      open_horizontal = "-";
      quit = "q";
      remove = "x";
      next_item = "]";
      prev_item = "[";
    };
    custom_actions = {
      open = "function(target_file_name, current_file_name) end";
      split_vertical = "function(target_file_name, current_file_name) end";
      split_horizontal = "function(target_file_name, current_file_name) end";
    };
    window = {
      width = "auto";
      height = "auto";
      row = "auto";
      col = "auto";
      border = "double";
    };
    per_buffer_config = {
      lines = 4;
      sort_automatically = true;
      satellite = {
        enable = false;
        overlap = true;
        priority = 1000;
      };
      zindex = 10;
    };
    separate_save_and_remove = false;
    leader_key = ";";
    save_key = "cwd";
    global_bookmarks = false;
    index_keys = "123456789zxcbnmZXVBNM,afghjklAFGHJKLwrtyuiopWRTYUIOP";
    full_path_list = [ "update_stuff" ];
  };
}
