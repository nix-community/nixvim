{
  empty = {
    colorscheme = "github_dark";
    colorschemes.github-theme.enable = true;
  };

  defaults = {
    colorscheme = "github_dark";
    colorschemes.github-theme = {
      enable = true;

      settings = {
        options = {
          compile_path.__raw = "vim.fn.stdpath('cache') .. '/github-theme'";
          compile_file_suffix = "_compiled";
          hide_end_of_buffer = true;
          hide_nc_statusline = true;
          transparent = false;
          terminal_colors = true;
          dim_inactive = false;
          module_default = true;
          styles = {
            comments = "NONE";
            functions = "NONE";
            keywords = "NONE";
            variables = "NONE";
            conditionals = "NONE";
            constants = "NONE";
            numbers = "NONE";
            operators = "NONE";
            strings = "NONE";
            types = "NONE";
          };
          inverse = {
            match_paren = false;
            visual = false;
            search = false;
          };
          darken = {
            floats = true;
            sidebars = {
              enable = true;
              list.__empty = { };
            };
          };
          modules.__empty = { };
        };
        palettes.__empty = { };
        specs.__empty = { };
        groups.__empty = { };
      };
    };
  };

  example = {
    colorscheme = "github_light";
    colorschemes.github-theme = {
      enable = true;

      settings = {
        transparent = true;
        dim_inactive = true;
        styles = {
          comments = "italic";
          keywords = "bold";
        };
      };
    };
  };
}
