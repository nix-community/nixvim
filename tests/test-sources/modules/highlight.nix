{
  example = {
    opts.termguicolors = true;

    highlight = {
      MacchiatoRed.fg = "#ed8796";
      # These two pin the widened types: raw Lua on a boolean, and the
      # `integer|string` the keyset gives every color attribute.
      Todo.bold.__raw = "true";
      WarningMsg.ctermfg = 1;
    };

    highlightOverride = {
      Normal.fg = "#ff0000";

      # With raw
      Normal.bg.__raw = "'#00ff00'";
    };
  };
}
