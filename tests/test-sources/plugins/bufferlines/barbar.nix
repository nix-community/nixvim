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

  defaults = {
    plugins.barbar = {
      enable = true;

      animation = true;
      autoHide = false;
      clickable = true;
      excludeFileTypes = [];
      excludeFileNames = [];
      focusOnClose = "left";
      hide = {};
      highlightAlternate = false;
      highlightInactiveFileIcons = false;
      highlightVisible = true;
      icons = {
        bufferIndex = false;
        bufferNumber = false;
        button = "";
        diagnostics = {};
        filetype = {
          enable = true;
        };
        inactive = {
          separator = {
            left = "▎";
            right = "";
          };
        };
        modified = {
          button = "●";
        };
        pinned = {
          button = "";
        };
        separator = {
          left = "▎";
          right = "";
        };
      };
      insertAtEnd = false;
      insertAtStart = false;
      letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP";
      maximumLength = 30;
      maximumPadding = 4;
      minimumPadding = 1;
      noNameTitle = null;
      semanticLetters = true;
      sidebarFiletypes = {};
      tabpages = true;
    };
  };
}
