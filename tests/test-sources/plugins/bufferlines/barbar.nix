{
  empty = {
    plugins.barbar.enable = true;
  };

  keymappings = {
    plugins.barbar = {
      enable = true;

      keymaps = {
        silent = true;

        next = "<TAB>";
        previous = "<S-TAB>";
        close = "<C-w>";
      };
    };
  };

  # All the upstream default options of barbar
  defaults = {
    plugins.barbar = {
      animations = true;
      autoHide = false;
      tabpages = true;
      closable = true;
      clickable = true;
      diagnostics = {
        error = {
          enable = false;
          icon = "Ⓧ ";
        };
        warn = {
          enable = false;
          icon = "⚠️ ";
        };
        info = {
          enable = false;
          icon = "ⓘ ";
        };
        hint = {
          enable = false;
          icon = "💡";
        };
      };
      excludeFileTypes = [];
      excludeFileNames = [];
      hide = {
        extensions = false;
        inactive = false;
        alternate = false;
        current = false;
        visible = false;
      };
      highlightAlternate = false;
      highlightInactiveFileIcons = false;
      highlightVisible = true;
      icons = {
        enable = true;
        customColors = false;
        separatorActive = "▎";
        separatorInactive = "▎";
        separatorVisible = "▎";
        closeTab = "";
        closeTabModified = "●";
        pinned = "車";
      };
      insertAtEnd = false;
      insertAtStart = false;
      maximumPadding = 4;
      minimumPadding = 1;
      maximumLength = 30;
      semanticLetters = true;
      letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP";
      noNameTitle = null;
    };
  };
}
