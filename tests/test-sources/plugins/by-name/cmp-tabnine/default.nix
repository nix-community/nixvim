{
  empty = {
    # 2026-10-17: TabNine downloads are no longer available
    # https://github.com/NixOS/nixpkgs/pull/569768
    test.buildNixvim = false;

    plugins = {
      cmp.enable = true;
      cmp-tabnine.enable = true;
    };
  };

  defaults = {
    # 2026-10-17: TabNine downloads are no longer available
    # https://github.com/NixOS/nixpkgs/pull/569768
    test.buildNixvim = false;

    plugins = {
      cmp.enable = true;
      cmp-tabnine = {
        enable = true;

        settings = {
          max_lines = 1000;
          max_num_results = 20;
          sort = true;
          run_on_every_keystroke = true;
          snippet_placeholder = "..";
          ignored_file_types.__empty = { };
          min_percent = 0;
        };
      };
    };
  };

  example = {
    # 2026-10-17: TabNine downloads are no longer available
    # https://github.com/NixOS/nixpkgs/pull/569768
    test.buildNixvim = false;

    plugins = {
      cmp.enable = true;
      cmp-tabnine = {
        enable = true;

        settings = {
          max_lines = 600;
          max_num_results = 10;
          sort = false;
        };
      };
    };
  };
}
