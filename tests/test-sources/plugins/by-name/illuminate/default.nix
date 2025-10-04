{
  empty = {
    plugins.illuminate.enable = true;
  };

  defaults = {
    plugins.illuminate = {
      enable = true;

      settings = {
        providers = [
          "lsp"
          "treesitter"
          "regex"
        ];
        delay = 100;
        filetype_overrides = { };
        filetypes_denylist = [
          "dirbuf"
          "dirvish"
          "fugitive"
        ];
        filetypes_allowlist = [ ];
        modes_denylist = [ ];
        modes_allowlist = [ ];
        providers_regex_syntax_denylist = [ ];
        providers_regex_syntax_allowlist = [ ];
        under_cursor = true;
        large_file_cutoff = 10000;
        large_file_overrides = null;
        min_count_to_highlight = 1;
      };
    };
  };

  example = {
    plugins.illuminate = {
      enable = true;

      settings = {
        delay = 200;
        providers = [
          "lsp"
          "treesitter"
        ];
        filetypes_denylist = [
          "dirbuf"
          "fugitive"
        ];
        under_cursor = false;
        min_count_to_highlight = 2;
      };
    };
  };
}
