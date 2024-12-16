{
  empty = {
    plugins.plantuml-syntax.enable = true;
  };

  defaults = {
    plugins.plantuml-syntax = {
      enable = true;

      settings = {
        set_makeprg = 1;
        executable_script = "plantuml";
      };
    };
  };
}
