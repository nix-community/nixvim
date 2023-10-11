{
  empty = {
    plugins.wilder.enable = true;
  };

  example = {
    plugins.wilder = {
      enable = true;

      enableCmdlineEnter = true;
      modes = ["/" "?"];
      wildcharm = "&wildchar";
      nextKey = "<Tab>";
      prevKey = "<S-Tab>";
      acceptKey = "<Down>";
      rejectKey = "<Up>";
      acceptCompletionAutoSelect = true;

      useCmdlinechanged = false;
      interval = 100;
      beforeCursor = false;
      usePythonRemotePlugin = true;
      numWorkers = 2;
      pipeline = [
        ''
          wilder.branch(
            wilder.cmdline_pipeline({
              language = 'python',
              fuzzy = 1,
            }),
            wilder.python_search_pipeline({
              pattern = wilder.python_fuzzy_pattern(),
              sorter = wilder.python_difflib_sorter(),
              engine = 're',
            })
          )
        ''
      ];
      render = ''
        wilder.wildmenu_renderer({
          -- highlighter applies highlighting to the candidates
          highlighter = wilder.basic_highlighter(),
        })
      '';
      preHook = null;
      postHook = null;
    };
  };
}
