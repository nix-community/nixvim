{helpers, ...}: {
  empty = {
    plugins.dashboard.enable = true;
  };

  defaults = {
    plugins.dashboard = {
      enable = true;

      changeVCSRoot = null;
      disableMove = null;
      footer = null;
      header = null;
      hideStatusline = null;
      hideTabline = null;
      hideWinbar = null;
      mru = null;
      project = null;
      shortcutType = null;
      showPackages = false;
      theme = null;

      center = [
        {
          icon = null;
          icon_hl = null;
          desc = null;
          desc_hl = null;
          key = null;
          key_hl = null;
          key_format = null;
          action = null;
        }
      ];

      preview = {
        command = null;
        file = null;
        height = null;
        width = null;
      };

      shortcut = [
        {
          desc = null;
          group = null;
          action = null;
        }
      ];

      weekHeader = {
        enable = null;
        concat = null;
        append = null;
      };
    };
  };
}
