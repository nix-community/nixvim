{
  empty = {
    plugins.marks.enable = true;
  };

  defaults = {
    plugins.marks = {
      enable = true;

      builtinMarks = [ ];
      defaultMappings = true;
      signs = true;
      cyclic = true;
      forceWriteShada = false;
      refreshInterval = 150;
      signPriority = 10;
      excludedFiletypes = [ ];
      excludedBuftypes = [ ];
      bookmarks = { };
      mappings = { };
    };
  };
}
