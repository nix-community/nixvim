{
  empty = {
    plugins.dashboard.enable = true;
  };

  example = {
    plugins.dashboard = {
      enable = true;

      theme = "hyper";
      disableMove = true;
      changeToVcsRoot = true;

      packages.enable = false;
      week_header.enable = false;

      hide = {
        statusline = true;
        tabline = true;
        winbar = true;
      };

      project = {
        enable = true;
        icon = "P";
        label = "Projects";
        limit = 8;
        action = "e ";
      };

      mru = {
        icon = "R";
        label = "Recent Files";
        limit = 10;
      };

      shortcut = [
        {
          icon = "O";
          desc = "Open Example File";
          key = "f";
          action = "e example.txt";
        }
      ];

      header = [
        "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
        "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
        "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
        "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
        "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
        "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
      ];

      footer = [
        "Made with ❤️ "
      ];
    };
  };
}
