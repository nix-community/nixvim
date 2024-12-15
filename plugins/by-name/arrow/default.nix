{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "arrow";
  packPathName = "arrow.nvim";
  package = "arrow-nvim";

  maintainers = [ maintainers.hmajid2301 ];

  settingsOptions = {
    show_icons = helpers.defaultNullOpts.mkBool false ''
      If true will show icons.
    '';

    always_show_path = helpers.defaultNullOpts.mkBool false ''
      If true will show path.
    '';

    separate_by_branch = helpers.defaultNullOpts.mkBool false ''
      If true will split bookmarks by git branch.
    '';

    hide_handbook = helpers.defaultNullOpts.mkBool false ''
      If true to hide the shortcuts on menu.
    '';

    save_path = helpers.defaultNullOpts.mkLuaFn ''
      function()
        return vim.fn.stdpath("cache") .. "/arrow"
      end
    '' "Function used to determine where to save arrow data.";

    mapping = {
      edit = helpers.defaultNullOpts.mkStr "e" ''
        Mapping to edit bookmarks.
      '';

      delete_mode = helpers.defaultNullOpts.mkStr "d" ''
        Mapping to go to delete mode, where you can remove bookmarks.
      '';

      clear_all_items = helpers.defaultNullOpts.mkStr "C" ''
        Mapping to clear all bookmarks.
      '';

      toggle = helpers.defaultNullOpts.mkStr "s" ''
        Mapping to save if `separate_save_and_remove` is true.
      '';

      open_vertical = helpers.defaultNullOpts.mkStr "v" ''
        Mapping to open bookmarks in vertical split.
      '';

      open_horizontal = helpers.defaultNullOpts.mkStr "-" ''
        Mapping to open bookmarks in horizontal split.
      '';

      quit = helpers.defaultNullOpts.mkStr "q" ''
        Mapping to quit arrow.
      '';

      remove = helpers.defaultNullOpts.mkStr "x" ''
        Mapping to remove bookmarks. Only used if `separate_save_and_remove` is true.
      '';

      next_item = helpers.defaultNullOpts.mkStr "]" ''
        Mapping to go to next bookmark.
      '';

      prev_item = helpers.defaultNullOpts.mkStr "[" ''
        Mapping to go to previous bookmark.
      '';
    };

    custom_actions = {
      open =
        helpers.defaultNullOpts.mkLuaFn
          ''
            function(target_file_name, current_file_name) end
          ''
          ''
            - `target_file_name`: file selected to be open
            - `current_file_name`: filename from where this was called
          '';

      split_vertical = helpers.defaultNullOpts.mkLuaFn ''
        function(target_file_name, current_file_name) end
      '' "";

      split_horizontal = helpers.defaultNullOpts.mkLuaFn ''
        function(target_file_name, current_file_name) end
      '' "";
    };

    window =
      helpers.defaultNullOpts.mkAttrsOf types.anything
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
      lines = helpers.defaultNullOpts.mkInt 4 ''
        Number of lines on preview.
      '';

      sort_automatically = helpers.defaultNullOpts.mkBool true ''
        If true will sort buffer marks automatically.
      '';

      satellite = {
        enable = helpers.defaultNullOpts.mkBool false ''
          If true will display arrow index in scrollbar at every update.
        '';

        overlap = helpers.defaultNullOpts.mkBool false '''';

        priority = helpers.defaultNullOpts.mkInt 1000 '''';
      };

      zindex = helpers.defaultNullOpts.mkInt 50 ''
        Z index of the buffer.
      '';
    };

    separate_save_and_remove = helpers.defaultNullOpts.mkBool false ''
      If true will remove the toggle and create the save/remove keymaps.
    '';

    leader_key = helpers.defaultNullOpts.mkStr ";" ''
      The leader key to use for arrow. Will precede all mappings.
      Recommended to be a single character.
    '';

    save_key = helpers.defaultNullOpts.mkStr "cwd" ''
      What will be used as root to save the bookmarks. Can be also `git_root`.
    '';

    global_bookmarks = helpers.defaultNullOpts.mkBool false ''
      If true arrow will save files globally (ignores `separate_by_branch`).
    '';

    index_keys = helpers.defaultNullOpts.mkStr "123456789zxcbnmZXVBNM,afghjklAFGHJKLwrtyuiopWRTYUIOP" ''
      Keys mapped to bookmark index.
    '';

    full_path_list = helpers.defaultNullOpts.mkListOf types.str [ "update_stuff" ] ''
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
