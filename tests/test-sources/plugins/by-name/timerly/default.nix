{
  empty = {
    plugins.timerly.enable = true;
  };

  example = {
    plugins = {
      timerly = {
        enable = true;

        settings = {
          on_start.__raw = "nil";
          on_finish.__raw = ''
            function()
              vim.notify "Time is up!"
              end
          '';
          minutes = [
            30
            10
          ];
          mapping.__raw = "nil";
          position = "top-left";
        };
      };
    };
  };
}
