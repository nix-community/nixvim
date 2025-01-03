{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "csvview";
  packPathName = "csvview.nvim";
  package = "csvview-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    parser = {
      async_chunksize = defaultNullOpts.mkUnsignedInt 50 ''
        The number of lines that the asynchronous parser processes per cycle.

        This setting is used to prevent monopolization of the main thread when displaying large
        files.

        If the UI freezes, try reducing this value.
      '';

      delimiter = defaultNullOpts.mkNullable' {
        type =
          with types;
          either str (submodule {
            freeformType = attrsOf anything;
            options = {
              default = defaultNullOpts.mkStr "," ''
                Default delimiter character.
              '';

              ft = defaultNullOpts.mkAttrsOf str { tsv = "\t"; } ''
                Filetype to delimiter character mapping.
              '';
            };
          });
        pluginDefault = {
          default = ",";
          ft = {
            tsv = "\t";
          };
        };
        example.__raw = "function(bufnr) return ',' end";
        description = ''
          The delimiter character.

          You can specify a string, an attrs of delimiter characters for each file type, or a
          function that returns a delimiter character.
        '';
      };

      quote_char = defaultNullOpts.mkStr' {
        pluginDefault = ''"'';
        example = "'";
        description = ''
          The quote character.

          If a field is enclosed in this character, it is treated as a single field and the delimiter
          in it will be ignored.

          You can also specify it on the command line.
          e.g:
          ```
          :CsvViewEnable quote_char='
          ```
        '';
      };

      comments = defaultNullOpts.mkListOf types.str [ "#" "--" "//" ] ''
        The comment prefix characters.

        If the line starts with one of these characters, it is treated as a comment.
        Comment lines are not displayed in tabular format.

        You can also specify it on the command line.
        e.g:
        ```
        :CsvViewEnable comment=#
        ```
      '';
    };

    view = {
      min_column_width = defaultNullOpts.mkUnsignedInt 5 ''
        Minimum width of a column.
      '';

      spacing = defaultNullOpts.mkUnsignedInt 2 ''
        Spacing between columns.
      '';

      display_mode = defaultNullOpts.mkEnumFirstDefault [ "highlight" "border" ] ''
        The display method of the delimiter.

        - `"highlight"` highlights the delimiter
        - `"border"` displays the delimiter with `│`

        see `Features` section of the README.
      '';
    };
  };

  settingsExample = {
    parser.async_chunksize = 30;
    view = {
      spacing = 4;
      display_mode = "border";
    };
  };
}
