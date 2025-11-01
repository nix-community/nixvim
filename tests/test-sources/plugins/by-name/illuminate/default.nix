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
        filetype_overrides.__empty = { };
        filetypes_denylist = [
          "dirbuf"
          "dirvish"
          "fugitive"
        ];
        filetypes_allowlist.__empty = { };
        modes_denylist.__empty = { };
        modes_allowlist.__empty = { };
        providers_regex_syntax_denylist.__empty = { };
        providers_regex_syntax_allowlist.__empty = { };
        under_cursor = true;
        large_file_cutoff = 10000;
        large_file_overrides.__raw = "nil";
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
