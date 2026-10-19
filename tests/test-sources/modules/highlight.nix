{
  # The submodule is freeform, so exercising values cannot detect a removed
  # declaration. Assert the declarations themselves.
  declares-nvim-set-hl-attrs =
    { lib, ... }:
    {
      # Pure eval, so no wrapped Neovim needs building.
      test.buildNixvim = false;

      assertions =
        map
          (name: {
            assertion = lib.types.highlight.getSubOptions [ ] ? ${name};
            message = "Expected `types.highlight` to declare `${name}`.";
          })
          [
            "altfont"
            "bg_indexed"
            "blink"
            "conceal"
            "dim"
            "fg_indexed"
            "force"
            "link_global"
            "overline"
            "update"
          ];
    };

  example = {
    opts.termguicolors = true;

    highlight = {
      MacchiatoRed = {
        fg = "#ed8796";
        ctermfg = "red";
        fg_indexed = true;
      };
      DiagnosticWarn = {
        bg = "#f5a97f";
        ctermbg = "yellow";
        bg_indexed = true;
        blink = true;
        overline = true;
      };
      Conceal = {
        altfont = true;
        conceal = true;
        dim = true;
      };
      LspReferenceText.link_global = "Normal";
      # These two pin the widened types: raw Lua on a boolean, and the
      # `integer|string` the keyset gives every color attribute.
      Todo.bold.__raw = "true";
      WarningMsg.ctermfg = 1;
    };

    highlightOverride = {
      # `highlightOverride` runs after `colorscheme`, so `update` has an
      # existing definition to merge into and `force` overrides `default`.
      Search = {
        bg = "#eed49f";
        default = true;
        force = true;
        update = true;
      };

      Normal.fg = "#ff0000";

      # With raw
      Normal.bg.__raw = "'#00ff00'";
    };
  };
}
