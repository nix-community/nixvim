{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts literalLua;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-surround";
  moduleName = "mini.surround";
  packPathName = "mini.surround";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    custom_surroundings = defaultNullOpts.mkAttrsOf types.anything (literalLua "nil") ''
      Add custom surroundings to be used on top of builtin ones.
      Should be a table with keys being single character surrounding identifier
      and values being surround specification tables with 'input' and 'output' fields.

      Examples:
      - Make ')' insert parts with spaces: `[')'] = { output = { left = '( ', right = ' )' } }`
      - User input surrounding: `['*'] = { input = function() ... end, output = function() ... end }`
    '';

    highlight_duration = defaultNullOpts.mkNum 500 ''
      Duration (in ms) of highlight when calling `MiniSurround.highlight()`.
    '';

    mappings =
      defaultNullOpts.mkNullableWithRaw
        (types.submodule {
          freeformType = with types; attrsOf anything;
          options = {
            add = defaultNullOpts.mkStr "sa" ''
              Add surrounding in Normal and Visual modes
            '';

            delete = defaultNullOpts.mkStr "sd" ''
              Delete surrounding
            '';

            find = defaultNullOpts.mkStr "sf" ''
              Find surrounding (to the right)
            '';

            find_left = defaultNullOpts.mkStr "sF" ''
              Find surrounding (to the left)
            '';

            highlight = defaultNullOpts.mkStr "sh" ''
              Highlight surrounding
            '';

            replace = defaultNullOpts.mkStr "sr" ''
              Replace surrounding
            '';

            update_n_lines = defaultNullOpts.mkStr "sn" ''
              Update `n_lines`
            '';

            suffix_last = defaultNullOpts.mkStr "l" ''
              Suffix to search with "prev" method
            '';

            suffix_next = defaultNullOpts.mkStr "n" ''
              Suffix to search with "next" method
            '';
          };
        })
        {
          add = "sa";
          delete = "sd";
          find = "sf";
          find_left = "sF";
          highlight = "sh";
          replace = "sr";
          update_n_lines = "sn";
          suffix_last = "l";
          suffix_next = "n";
        }
        ''
          Module mappings. Use empty string to disable one.
        '';

    n_lines = defaultNullOpts.mkNum 20 ''
      Number of lines within which surrounding is searched.
    '';

    respect_selection_type = defaultNullOpts.mkBool false ''
      Whether to respect selection type:
      - Place surroundings on separate lines in linewise mode.
      - Place surroundings on each line in blockwise mode.
    '';

    search_method =
      defaultNullOpts.mkEnum
        [
          "cover"
          "cover_or_next"
          "cover_or_prev"
          "cover_or_nearest"
          "next"
          "prev"
          "nearest"
        ]
        "cover"
        ''
          How to search for surrounding (first inside current line, then inside neighborhood).
          One of 'cover', 'cover_or_next', 'cover_or_prev', 'cover_or_nearest', 'next', 'prev', 'nearest'.
        '';

    silent = defaultNullOpts.mkBool false ''
      Whether to disable showing non-error feedback.
      This also affects (purely informational) helper messages shown after idle time if user input is required.
    '';
  };

  settingsExample = {
    n_lines = 50;
    respect_selection_type = true;
    search_method = "cover_or_next";
  };
}
