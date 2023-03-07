{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.plugins.barbar;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.barbar = {
    enable = mkEnableOption "barbar.nvim";

    package = helpers.mkPackageOption "barbar" pkgs.vimPlugins.barbar-nvim;

    animations = helpers.defaultNullOpts.mkBool true "Enable animations";

    autoHide = helpers.defaultNullOpts.mkBool false "Auto-hide the tab bar when there is only one buffer";

    tabpages = helpers.defaultNullOpts.mkBool true "current/total tabpages indicator (top right corner)";

    closable = helpers.defaultNullOpts.mkBool true "Enable the close button";

    clickable = helpers.defaultNullOpts.mkBool true ''
      Enable clickable tabs
        - left-click: go to buffer
        - middle-click: delete buffer
    '';

    diagnostics = {
      error = {
        enable = helpers.defaultNullOpts.mkBool false "Enable the error diagnostic symbol";
        icon = helpers.defaultNullOpts.mkStr "Ⓧ " "Error diagnostic symbol";
      };
      warn = {
        enable = helpers.defaultNullOpts.mkBool false "Enable the warning diagnostic symbol";
        icon = helpers.defaultNullOpts.mkStr "⚠️ " "Warning diagnostic symbol";
      };
      info = {
        enable = helpers.defaultNullOpts.mkBool false "Enable the info diagnostic symbol";
        icon = helpers.defaultNullOpts.mkStr "ⓘ " "Info diagnostic symbol";
      };
      hint = {
        enable = helpers.defaultNullOpts.mkBool false "Enable the hint diagnostic symbol";
        icon = helpers.defaultNullOpts.mkStr "💡" "Hint diagnostic symbol";
      };
    };

    excludeFileTypes = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "{}" ''
      Excludes buffers of certain filetypes from the tabline
    '';

    excludeFileNames = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "{}" ''
      Excludes buffers with certain filenames from the tabline
    '';

    hide = {
      extensions = helpers.defaultNullOpts.mkBool false "Hide file extensions";
      inactive = helpers.defaultNullOpts.mkBool false "Hide inactive buffers";
      alternate = helpers.defaultNullOpts.mkBool false "Hide alternate buffers";
      current = helpers.defaultNullOpts.mkBool false "Hide current buffer";
      visible = helpers.defaultNullOpts.mkBool false "Hide visible buffers";
    };

    highlightAlternate = helpers.defaultNullOpts.mkBool false "Highlight alternate buffers";

    highlightInactiveFileIcons = helpers.defaultNullOpts.mkBool false "Highlight file icons in inactive buffers";

    highlightVisible = helpers.defaultNullOpts.mkBool true "Highlight visible buffers";

    icons = {
      enable =
        helpers.defaultNullOpts.mkNullable
        (with types; (either bool (enum ["numbers" "both"])))
        "true"
        ''
          Enable/disable icons if set to 'numbers', will show buffer index in the tabline if set to
          'both', will show buffer index and icons in the tabline
        '';

      customColors =
        helpers.defaultNullOpts.mkNullable
        (types.either types.bool types.str)
        "false"
        ''
          If set, the icon color will follow its corresponding buffer
          highlight group. By default, the Buffer*Icon group is linked to the
          Buffer* group (see Highlighting below). Otherwise, it will take its
          default value as defined by devicons.
        '';

      separatorActive = helpers.defaultNullOpts.mkStr "▎" "Icon for the active tab separator";
      separatorInactive = helpers.defaultNullOpts.mkStr "▎" "Icon for the inactive tab separator";
      separatorVisible = helpers.defaultNullOpts.mkStr "▎" "Icon for the visible tab separator";
      closeTab = helpers.defaultNullOpts.mkStr "" "Icon for the close tab button";
      closeTabModified = helpers.defaultNullOpts.mkStr "●" "Icon for the close tab button of a modified buffer";
      pinned = helpers.defaultNullOpts.mkStr "車" "Icon for the pinned tabs";
    };

    insertAtEnd = helpers.defaultNullOpts.mkBool false ''
      If true, new buffers will be inserted at the end of the list.
      Default is to insert after current buffer.
    '';
    insertAtStart = helpers.defaultNullOpts.mkBool false ''
      If true, new buffers will be inserted at the start of the list.
      Default is to insert after current buffer.
    '';

    maximumPadding = helpers.defaultNullOpts.mkInt 4 "Sets the maximum padding width with which to surround each tab";
    minimumPadding = helpers.defaultNullOpts.mkInt 1 "Sets the minimum padding width with which to surround each tab";
    maximumLength = helpers.defaultNullOpts.mkInt 30 "Sets the maximum buffer name length.";

    semanticLetters = helpers.defaultNullOpts.mkBool true ''
      If set, the letters for each buffer in buffer-pick mode will be assigned based on their name.
      Otherwise or in case all letters are already assigned, the behavior is to assign letters in
      order of usability (see `letters` option)
    '';

    letters = helpers.defaultNullOpts.mkStr "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP" ''
      New buffer letters are assigned in this order.
      This order is optimal for the qwerty keyboard layout but might need adjustement for other layouts.
    '';

    noNameTitle = helpers.mkNullOrOption types.str ''
      Sets the name of unnamed buffers. By default format is "[Buffer X]" where X is the buffer number.
      But only a static string is accepted here.
    '';

    # Keybinds concept:
    # keys = {
    #   previousBuffer = mkBindDef "normal" "Previous buffer" { action = ":BufferPrevious<CR>"; silent = true; } "<A-,>";
    #   nextBuffer = mkBindDef "normal" "Next buffer" { action = ":BufferNext<CR>"; silent = true; } "<A-.>";
    #   movePrevious = mkBindDef "normal" "Re-order to previous" { action = ":BufferMovePrevious<CR>"; silent = true; } "<A-<>";
    #   moveNext = mkBindDef "normal" "Re-order to next" { action = ":BufferMoveNext<CR>"; silent = true; } "<A->>";

    #   # TODO all the other ones.....
    # };
  };

  config = let
    setupOptions = {
      animation = cfg.animations;
      auto_hide = cfg.autoHide;
      clickable = cfg.clickable;
      closable = cfg.closable;

      diagnostics = [
        cfg.diagnostics.error
        cfg.diagnostics.warn
        cfg.diagnostics.info
        cfg.diagnostics.hint
      ];

      exclude_ft = cfg.excludeFileTypes;
      exclude_name = cfg.excludeFileNames;

      hide = cfg.hide;

      highlight_alternate = cfg.highlightAlternate;
      highlight_inactive_file_icons = cfg.highlightInactiveFileIcons;
      highlight_visible = cfg.highlightVisible;

      icon_close_tab = cfg.icons.closeTab;
      icon_close_tab_modified = cfg.icons.closeTabModified;
      icon_pinned = cfg.icons.pinned;
      icon_separator_active = cfg.icons.separatorActive;
      icon_separator_inactive = cfg.icons.separatorInactive;
      icon_separator_visible = cfg.icons.separatorVisible;
      icons = cfg.icons.enable;
      icon_custom_colors = cfg.icons.customColors;

      insert_at_start = cfg.insertAtStart;
      insert_at_end = cfg.insertAtEnd;

      letters = cfg.letters;

      maximum_padding = cfg.maximumPadding;
      minimum_padding = cfg.minimumPadding;
      maximum_length = cfg.maximumLength;

      no_name_title = cfg.noNameTitle;

      semantic_letters = cfg.semanticLetters;

      tabpages = cfg.tabpages;
    };
  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [
        cfg.package
        nvim-web-devicons
      ];

      extraConfigLua = ''
        require('bufferline').setup(${helpers.toLuaObject setupOptions})
      '';

      # maps = genMaps cfg.keys;
    };
}
