{
  empty = {
    plugins.git-conflict.enable = true;
  };

  defaults = {
    plugins.git-conflict = {
      enable = true;

      settings = {
        default_mappings = true;
        default_commands = true;
        disable_diagnostics = false;
        list_opener = "copen";
        highlights = {
          incoming = "DiffAdd";
          current = "DiffText";
          ancestor.__raw = "nil";
        };
      };
    };
  };

  example = {
    plugins.git-conflict = {
      enable = true;

      settings = {
        default_mappings = {
          ours = "o";
          theirs = "t";
          none = "0";
          both = "b";
          next = "n";
          prev = "p";
        };
        default_commands = true;
        disable_diagnostics = false;
        list_opener = "copen";
        highlights = {
          incoming = "DiffAdd";
          current = "DiffText";
        };
      };
    };
  };
}
