{
  example = {
    opts.termguicolors = true;

    highlight = {
      MacchiatoRed.fg = "#ed8796";
      # Boolean attributes take raw Lua, like the string attributes
      Todo.bold.__raw = "true";
    };

    highlightOverride = {
      Normal.fg = "#ff0000";

      # With raw
      Normal.bg.__raw = "'#00ff00'";
    };
  };
}
