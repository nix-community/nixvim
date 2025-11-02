{
  empty = {
    colorschemes.vscode.enable = true;
  };

  defaults = {
    colorschemes.vscode = {
      enable = true;
      settings = {
        transparent = false;
        italic_comments = false;
        italic_inlayhints = false;
        underline_links = false;
        color_overrides = false;
        group_overrides = { };
        disable_nvimtree_bg = true;
        terminal_colors = true;
      };
    };
  };

  example = {
    colorschemes.vscode = {
      enable = true;
      settings = {
        transparent = true;
        italic_comments = true;
        italic_inhayhints = true;
        underline_links = true;
        terminal_colors = true;
        color_overrides = {
          vscLineNumber = "#FFFFFF";
        };
      };
    };
  };
}
