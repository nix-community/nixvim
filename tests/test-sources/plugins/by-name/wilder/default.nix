{ lib }:
{
  empty = {
    plugins.wilder.enable = true;
  };

  example = {
    plugins.wilder = {
      enable = true;

      settings = {
        enable_cmdline_enter = true;
        modes = [
          "/"
          "?"
        ];
        wildcharm = "&wildchar";
        next_key = "<Tab>";
        previous_key = "<S-Tab>";
        accept_key = "<Down>";
        reject_key = "<Up>";
        accept_completion_auto_select = true;
      };

      options = {
        use_cmdlinechanged = false;
        interval = 100;
        before_cursor = false;
        use_python_remote_plugin = true;
        num_workers = 2;
        pipeline = [
          (lib.nixvim.mkRaw ''
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
          '')
        ];
        renderer = lib.nixvim.mkRaw ''
          wilder.wildmenu_renderer({
            -- highlighter applies highlighting to the candidates
            highlighter = wilder.basic_highlighter(),
          })
        '';
        pre_hook = null;
        post_hook = null;
      };
    };
  };
}
