{
  empty = {
    plugins.aider.enable = true;
  };

  defaults = {
    plugins.aider = {
      enable = true;
      settings = {
        auto_manage_context = true;
        default_bindings = true;
        debug = false;
        ignore_buffers = [
          "^term://"
          "NeogitConsole"
          "NvimTree_"
          "neo-tree filesystem"
        ];
      };
    };
  };

  example = {
    plugins.aider = {
      enable = true;

      settings = {
        auto_manage_context = false;
        default_bindings = false;
        debug = true;
        vim = true;
        ignore_buffers.__empty = { };
        border = {
          style = [
            "╭"
            "─"
            "╮"
            "│"
            "╯"
            "─"
            "╰"
            "│"
          ];
          color = "#fab387";
        };
      };
    };
  };
}
