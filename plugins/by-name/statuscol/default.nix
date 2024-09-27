{
  lib,
  helpers,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "statuscol";
  originalName = "statuscol.nvim";
  package = "statuscol-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    setopt = helpers.defaultNullOpts.mkBool true ''
      Whether to set the `statuscolumn` option, may be set to false for those who want to use the
      click handlers in their own `statuscolumn`: `_G.Sc[SFL]a()`.
      Although I recommend just using the segments field below to build your statuscolumn to
      benefit from the performance optimizations in this plugin.
    '';

    thousands = helpers.defaultNullOpts.mkNullable (with types; either str (enum [ false ])) false ''
      `false` or line number thousands separator string ("." / ",").
    '';

    relculright = helpers.defaultNullOpts.mkBool false ''
      Whether to right-align the cursor line number with `relativenumber` set.
    '';

    ft_ignore = helpers.defaultNullOpts.mkListOf types.str null ''
      Lua table with 'filetype' values for which `statuscolumn` will be unset.
    '';

    bt_ignore = helpers.defaultNullOpts.mkListOf types.str null ''
      Lua table with 'buftype' values for which `statuscolumn` will be unset.
    '';

    segments =
      let
        segmentType = types.submodule {
          freeformType = with types; attrsOf anything;
          options = {
            text = mkOption {
              type = with lib.types; nullOr (listOf (either str rawLua));
              default = null;
              description = "Segment text.";
              example = [ "%C" ];
            };

            click = helpers.mkNullOrStr ''
              `%@` click function label, applies to each text element.
            '';

            hl = helpers.mkNullOrStr ''
              `%#` highlight group label, applies to each text element.
            '';

            condition = helpers.mkNullOrOption (
              with lib.types; listOf (either bool rawLua)
            ) "Table of booleans or functions returning a boolean.";

            sign = {
              name = helpers.defaultNullOpts.mkListOf types.str [ ] ''
                List of lua patterns to match the sign name against.
              '';

              text = helpers.defaultNullOpts.mkListOf types.str [ ] ''
                List of lua patterns to match the extmark sign text against.
              '';

              namespace = helpers.defaultNullOpts.mkListOf types.str [ ] ''
                List of lua patterns to match the extmark sign namespace against.
              '';

              maxwidth = helpers.defaultNullOpts.mkUnsignedInt 1 ''
                Maximum number of signs that will be displayed in this segment
              '';

              colwidth = helpers.defaultNullOpts.mkUnsignedInt 2 ''
                Maximum number of display cells per sign in this segment.
              '';

              auto = helpers.defaultNullOpts.mkBool false ''
                When true, the segment will not be drawn if no signs matching the pattern are
                currently placed in the buffer.
              '';

              fillchar = helpers.defaultNullOpts.mkStr " " ''
                Character used to fill a segment with less signs than maxwidth.
              '';

              fillcharhl = helpers.mkNullOrStr ''
                Highlight group used for fillchar (SignColumn/CursorLineSign if omitted).
              '';
            };
          };
        };
      in
      helpers.defaultNullOpts.mkListOf segmentType [
        {
          text = [ "%C" ];
          click = "v:lua.ScFa";
        }
        {
          text = [ "%s" ];
          click = "v:lua.ScSa";
        }
        {
          text = [
            { __raw = "require('statuscol.builtin').lnumfunc"; }
            " "
          ];
          condition = [
            true
            { __raw = "require('statuscol.builtin').not_empty"; }
          ];
          click = "v:lua.ScLa";
        }
      ] "The statuscolumn can be customized through the `segments` option.";

    clickmod = helpers.defaultNullOpts.mkStr "c" ''
      Modifier used for certain actions in the builtin clickhandlers:
      `a` for Alt, `c` for Ctrl and `m` for Meta.
    '';

    clickhandlers = mkOption {
      type = with lib.types; attrsOf strLuaFn;
      default = { };
      description = ''
        Builtin click handlers.
      '';
      apply = mapAttrs (_: helpers.mkRaw);
      example = {
        Lnum = "require('statuscol.builtin').lnum_click";
        FoldClose = "require('statuscol.builtin').foldclose_click";
        FoldOpen = "require('statuscol.builtin').foldopen_click";
        FoldOther = "require('statuscol.builtin').foldother_click";
      };
    };
  };

  settingsExample = {
    setopt = true;
    thousands = ".";
    relculright = true;
    ft_ignore = null;
    bt_ignore = null;
    segments = [
      {
        text = [ "%C" ];
        click = "v:lua.ScFa";
      }
      {
        text = [ "%s" ];
        click = "v:lua.ScSa";
      }
      {
        text = [
          { __raw = "require('statuscol.builtin').lnumfunc"; }
          " "
        ];
        condition = [
          true
          { __raw = "require('statuscol.builtin').not_empty"; }
        ];
        click = "v:lua.ScLa";
      }
    ];
    clickmod = "c";
    clickhandlers = {
      Lnum = "require('statuscol.builtin').lnum_click";
      FoldClose = "require('statuscol.builtin').foldclose_click";
      FoldOpen = "require('statuscol.builtin').foldopen_click";
      FoldOther = "require('statuscol.builtin').foldother_click";
    };
  };
}
