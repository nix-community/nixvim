{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts literalLua;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-ai";
  moduleName = "mini.ai";
  packPathName = "mini.ai";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    custom_textobjects = defaultNullOpts.mkAttrsOf types.anything (literalLua "nil") ''
      Table with textobject id as fields, textobject specification as values.
      Also use this to disable builtin textobjects.
    '';

    mappings =
      defaultNullOpts.mkNullableWithRaw
        (types.submodule {
          freeformType = with types; attrsOf anything;
          options = {
            around = defaultNullOpts.mkStr "a" ''
              Main textobject prefix for "around" textobject
            '';

            inside = defaultNullOpts.mkStr "i" ''
              Main textobject prefix for "inside" textobject
            '';

            around_next = defaultNullOpts.mkStr "an" ''
              Next variant for "around" textobject
            '';

            inside_next = defaultNullOpts.mkStr "in" ''
              Next variant for "inside" textobject
            '';

            around_last = defaultNullOpts.mkStr "al" ''
              Last variant for "around" textobject
            '';

            inside_last = defaultNullOpts.mkStr "il" ''
              Last variant for "inside" textobject
            '';

            goto_left = defaultNullOpts.mkStr "g[" ''
              Move cursor to corresponding left edge of "a" textobject
            '';

            goto_right = defaultNullOpts.mkStr "g]" ''
              Move cursor to corresponding right edge of "a" textobject
            '';
          };
        })
        {
          around = "a";
          inside = "i";
          around_next = "an";
          inside_next = "in";
          around_last = "al";
          inside_last = "il";
          goto_left = "g[";
          goto_right = "g]";
        }
        ''
          Module mappings. Use empty string to disable one.
        '';

    n_lines = defaultNullOpts.mkNum 50 ''
      Number of lines within which textobject is searched
    '';

    search_method =
      defaultNullOpts.mkEnum
        [
          "cover"
          "cover_or_next"
          "cover_or_prev"
          "cover_or_nearest"
          "next"
          "previous"
          "nearest"
        ]
        "cover_or_next"
        ''
          How to search for object (first inside current line, then inside neighborhood).
        '';

    silent = defaultNullOpts.mkBool false ''
      Whether to disable showing non-error feedback.
      This also affects (purely informational) helper messages shown after idle time if user input is required.
    '';
  };

  settingsExample = {
    n_line = 500;
    search_method = "cover_or_nearest";
    silent = true;
  };
}
