{
  empty = {
    plugins.scope.enable = true;
  };
  defaults = {
    plugins.scope = {
      enable = true;

      settings.hooks = {
        pre_tab_enter = null;
        post_tab_enter = null;
        pre_tab_leave = null;
        post_tab_leave = null;
        pre_tab_close = null;
        post_tab_close = null;
      };
    };
  };
  example = {
    plugins.scope = {
      enable = true;

      settings = {
        hooks = {
          pre_tab_enter.__raw = ''
            function()
              print("Example hook, about to enter tab")
            end
          '';
        };
      };
    };
  };
}
