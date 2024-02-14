{
  empty = {
    plugins.julia-cell.enable = true;
  };

  example = {
    plugins.julia-cell = {
      enable = true;

      settings = {
        delimit_cells_by = "marks";
        tag = "##";
      };

      keymaps = {
        silent = true;

        executeCell = "a";
        executeCellJump = "b";
        run = "c";
        clear = "d";
        prevCell = "e";
        nextCell = "f";
      };
    };
  };
}
