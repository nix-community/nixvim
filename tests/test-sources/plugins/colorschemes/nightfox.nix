{
  empty = {
    colorschemes.nightfox.enable = true;
  };

  defaults = {
    colorschemes.nightfox = {
      enable = true;

      settings = {
        options = {
          compile_path.__raw = "vim.fn.stdpath('cache') .. '/nightfox'";
          compile_file_suffix = "_compiled";
          transparent = false;
          terminal_colors = true;
          dim_inactive = false;
          module_default = true;
          styles = {
            comments = "NONE";
            conditionals = "NONE";
            constants = "NONE";
            functions = "NONE";
            keywords = "NONE";
            numbers = "NONE";
            operators = "NONE";
            preprocs = "NONE";
            strings = "NONE";
            types = "NONE";
            variables = "NONE";
          };
          inverse = {
            match_paren = false;
            visual = false;
            search = false;
          };
          colorblind = {
            enable = false;
            simulate_only = false;
            severity = {

              protan = 0;
              deutan = 0;
              tritan = 0;
            };
          };
          modules = {
            coc = {
              background = true;
            };
            diagnostic = {
              enable = true;
              background = true;
            };
            native_lsp = {
              enable = true;
              background = true;
            };
            treesitter = true;
            lsp_semantic_tokens = true;
            leap = {
              background = true;
            };
          };
        };
        palettes.__empty = { };
        specs.__empty = { };
        groups.__empty = { };
      };
    };
  };

  example = {
    colorschemes.nightfox = {
      enable = true;

      flavor = "dayfox";

      settings = {
        options = {
          transparent = true;
          terminal_colors = true;
          styles = {
            comments = "italic";
            functions = "italic,bold";
          };
          inverse = {
            match_paren = false;
            visual = false;
            search = true;
          };
          colorblind = {
            enable = true;
            severity = {
              protan = 0.3;
              deutan = 0.6;
            };
          };
          modules = {
            coc.background = false;
            diagnostic = {
              enable = true;
              background = false;
            };
          };
        };
        palettes.duskfox = {
          bg1 = "#000000";
          bg0 = "#1d1d2b";
          bg3 = "#121820";
          sel0 = "#131b24";
        };
        specs = {
          all.inactive = "bg0";
          duskfox.inactive = "#090909";
        };
        groups.all.NormalNC = {
          fg = "fg1";
          bg = "inactive";
        };
      };
    };
  };
}
