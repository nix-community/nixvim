{ lib }:
{
  empty = {
    colorscheme = "vague";
    colorschemes.vague.enable = true;
  };

  defaults = {
    colorscheme = "vague";

    colorschemes.vague = {
      enable = true;
      settings = {
        transparent = false;
        bold = true;
        italic = true;
        style = {
          boolean = "bold";
          number = "none";
          float = "none";
          error = "bold";
          comments = "italic";
          conditionals = "none";
          functions = "none";
          headings = "bold";
          operators = "none";
          strings = "italic";
          variables = "none";

          keywords = "none";
          keyword_return = "italic";
          keywords_loop = "none";
          keywords_label = "none";
          keywords_exception = "none";

          builtin_constants = "bold";
          builtin_functions = "none";
          builtin_types = "bold";
          builtin_variables = "none";
        };
        plugins = {
          cmp = {
            match = "bold";
            match_fuzzy = "bold";
          };
          dashboard = {
            footer = "italic";
          };
          lsp = {
            diagnostic_error = "bold";
            diagnostic_hint = "none";
            diagnostic_info = "italic";
            diagnostic_ok = "none";
            diagnostic_warn = "bold";
          };
          neotest = {
            focused = "bold";
            adapter_name = "bold";
          };
          telescope = {
            match = "bold";
          };
        };

        on_highlights = lib.nixvim.mkRaw "function(highlights, colors) end";

        colors = {
          bg = "#141415";
          inactiveBg = "#1c1c24";
          fg = "#cdcdcd";
          floatBorder = "#878787";
          line = "#252530";
          comment = "#606079";
          builtin = "#b4d4cf";
          func = "#c48282";
          string = "#e8b589";
          number = "#e0a363";
          property = "#c3c3d5";
          constant = "#aeaed1";
          parameter = "#bb9dbd";
          visual = "#333738";
          error = "#d8647e";
          warning = "#f3be7c";
          hint = "#7e98e8";
          operator = "#90a0b5";
          keyword = "#6e94b2";
          type = "#9bb4bc";
          search = "#405065";
          plus = "#7fa563";
          delta = "#f3be7c";
        };
      };
    };
  };

  example = {
    colorscheme = "vague";

    colorschemes.vague = {
      enable = true;

      settings = {
        bold = false;
        italic = false;
      };
    };
  };
}
