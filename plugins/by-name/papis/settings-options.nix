lib:
let
  inherit (lib) types;
  inherit (lib.nixvim)
    defaultNullOpts
    literalLua
    mkNullOrOption
    mkNullOrStr
    ;
in
{
  enable_modules =
    defaultNullOpts.mkAttrsOf types.bool
      {
        search = true;
        completion = true;
        at-cursor = true;
        formatter = true;
        colors = true;
        base = true;
        debug = false;
      }
      ''
        List of enabled modules.
      '';

  cite_formats =
    defaultNullOpts.mkAttrsOf
      (
        with types;
        oneOf [
          str
          (listOf str)
          (submodule {
            freeformType = with types; attrsOf anything;
            options = {
              start_str = mkNullOrStr ''
                Precedes the citation.
              '';

              end_str = mkNullOrStr ''
                Appended after the citation.
              '';

              ref_prefix = mkNullOrStr ''
                precedes each `ref` in a citation.
              '';

              separator_str = mkNullOrStr ''
                Gets added between `ref`s if there are multiple in a citation.
              '';
            };
          })
        ]
      )
      {
        tex = {
          start_str = "[[\cite{]]";
          end_str = "}";
          separator_str = ", ";
        };
        markdown = {
          ref_prefix = "@";
          separator_str = "; ";
        };
        rmd = {
          ref_prefix = "@";
          separator_str = "; ";
        };
        plain = {
          separator_str = ", ";
        };
        org = {
          start_str = "[cite:";
          end_str = "]";
          ref_prefix = "@";
          separator_str = ";";
        };
        norg = {
          start_str = "{= ";
          end_str = "}";
          separator_str = "; ";
        };
        typst = {
          ref_prefix = "@";
          separator_str = " ";
        };
      }
      ''
        Defines citation formats for various filetypes. They define how citation strings are parsed
        and formatted when inserted.
      '';

  cite_formats_fallback = defaultNullOpts.mkStr "plain" ''
    What citation format to use when none is defined for the current filetype.
  '';

  enable_keymaps = defaultNullOpts.mkBool false ''
    Enable default keymaps.
  '';

  enable_fs_watcher = defaultNullOpts.mkBool true ''
    Whether to enable the file system event watcher.

    When disabled, the database is only updated on startup.
  '';

  data_tbl_schema =
    defaultNullOpts.mkAttrsOf
      (
        with types;
        either str (submodule {
          freeformType = attrsOf anything;
          options = {
            __unkeyed-type = mkNullOrStr ''
              The type for this field.
              Only the "text" and "luatable" are allowed.
            '';

            required = mkNullOrOption types.bool ''
              Whether this field is required.
            '';

            unique = mkNullOrOption types.bool ''
              Whether this field is unique.
            '';
          };
        })
      )
      {
        id = {
          __unkeyed-type = "integer";
          pk = true;
        };
        papis_id = {
          __unkeyed-type = "text";
          required = true;
          unique = true;
        };
        ref = {
          __unkeyed-type = "text";
          required = true;
          unique = true;
        };
        author = "text";
        editor = "text";
        year = "text";
        title = "text";
        shorttitle = "text";
        type = "text";
        abstract = "text";
        time_added = "text";
        notes = "luatable";
        journal = "text";
        volume = "text";
        number = "text";
        author_list = "luatable";
        tags = "luatable";
        files = "luatable";
      }
      ''
        The sqlite schema of the main `data` table.

        Only the `"text"` and `"luatable"` types are allowed.
      '';

  db_path = defaultNullOpts.mkStr (literalLua "vim.fn.stdpath('data') .. '/papis_db/papis-nvim.sqlite3'") ''
    Path to the papis.nvim database.
  '';

  yq_bin = defaultNullOpts.mkStr "yq" ''
    Name of the `yq` executable.
  '';

  create_new_note_fn =
    defaultNullOpts.mkRaw
      ''
        function(papis_id, notes_name)
          vim.fn.system(
            string.format(
              "papis update --set notes %s papis_id:%s",
              vim.fn.shellescape(notes_name),
              vim.fn.shellescape(papis_id)
            )
          )
        end
      ''
      ''
        Function to execute when adding a new note. `ref` is the citation key of the relevant entry
        and `notes_name` is the name of the notes file.
      '';

  init_filetypes = defaultNullOpts.mkListOf types.str [ "markdown" "norg" "yaml" "typst" ] ''
    Filetypes that start papis.nvim.
  '';

  papis_conf_keys =
    defaultNullOpts.mkListOf types.str [ "info-name" "notes-name" "dir" "opentool" ]
      ''
        Papis options to import into papis.nvim.
      '';

  enable_icons = defaultNullOpts.mkBool true ''
    Whether to enable pretty icons (requires something like Nerd Fonts).
  '';

  search = {
    wrap = defaultNullOpts.mkBool true ''
      Whether to enable line wrap in the telescope previewer.
    '';

    initial_sort_by_time_added = defaultNullOpts.mkBool true ''
      Whether to initially sort entries by time-added.
    '';

    search_keys = defaultNullOpts.mkListOf types.str [ "author" "editor" "year" "title" "tags" ] ''
      What keys to search for matches.
    '';

    preview_format =
      defaultNullOpts.mkListOf (with types; listOf (either str (listOf str)))
        [
          [
            "author"
            "%s"
            "PapisPreviewAuthor"
          ]
          [
            "year"
            "%s"
            "PapisPreviewYear"
          ]
          [
            "title"
            "%s"
            "PapisPreviewTitle"
          ]
          [ "empty_line" ]
          [
            "journal"
            "%s"
            "PapisPreviewValue"
            "show_key"
            [
              "󱀁  "
              "%s: "
            ]
            "PapisPreviewKey"
          ]
          [
            "type"
            "%s"
            "PapisPreviewValue"
            "show_key"
            [
              "  "
              "%s: "
            ]
            "PapisPreviewKey"
          ]
          [
            "ref"
            "%s"
            "PapisPreviewValue"
            "show_key"
            [
              "  "
              "%s: "
            ]
            "PapisPreviewKey"
          ]
          [
            "tags"
            "%s"
            "PapisPreviewValue"
            "show_key"
            [
              "  "
              "%s: "
            ]
            "PapisPreviewKey"
          ]
          [
            "abstract"
            "%s"
            "PapisPreviewValue"
            "show_key"
            [
              "󰭷  "
              "%s: "
            ]
            "PapisPreviewKey"
          ]
        ]
        ''
          Papis.nvim uses a common configuration format for defining the formatting of strings.

          Sometimes -- as for instance in the below `preview_format` option -- we define a set of
          lines.
          At other times -- as for instance in the `results_format` option -- we define a single
          line.

          Sets of lines are composed of single lines.
          A line can be composed of either a single element or multiple elements.
          The below `preview_format` shows an example where each line is defined by a table with
          just one element.
        '';

    results_format =
      defaultNullOpts.mkListOf (with types; listOf (either str (listOf str)))
        [
          [
            "files"
            [
              " "
              "F "
            ]
            "PapisResultsFiles"
            "force_space"
          ]
          [
            "notes"
            [
              "󰆈 "
              "N "
            ]
            "PapisResultsNotes"
            "force_space"
          ]
          [
            "author"
            "%s "
            "PapisResultsAuthor"
          ]
          [
            "year"
            "(%s) "
            "PapisResultsYear"
          ]
          [
            "title"
            "%s"
            "PapisResultsTitle"
          ]
        ]
        ''
          The format of each line in the the results window.
          Here, everything is show on one line (otherwise equivalent to points 1-3 of
          `preview_format`).

          The `force_space` value is used to force whitespace for icons (so that if e.g. a file is
          absent, it will show "  ", ensuring that columns are aligned.)
        '';
  };

  at-cursor = {
    popup_format =
      defaultNullOpts.mkListOf (with types; listOf (either str (listOf str)))
        [
          [
            "author"
            "%s"
            "PapisPopupAuthor"
          ]
          [
            "vspace"
            "vspace"
          ]
          [
            "files"
            [
              " "
              "F "
            ]
            "PapisResultsFiles"
          ]
          [
            "notes"
            [
              "󰆈 "
              "N "
            ]
            "PapisResultsNotes"
          ]
          [
            "year"
            "%s"
            "PapisPopupYear"
          ]
          [
            "title"
            "%s"
            "PapisPopupTitle"
          ]
        ]
        ''
          The format of the popup shown on `:Papis at-cursor show-popup` (equivalent to points 1-3
          of `preview_format`).

          Note that one of the lines is composed of multiple elements.

          Note also the `[ "vspace" "vspace" ]` line which is exclusive to `popup_format` and which
          tells papis.nvim to fill the space between the previous and next element with whitespace
          (and in effect make whatever comes after right-aligned).
          It can only occur once in a line.
        '';
  };

  formatter = {
    format_notes = mkNullOrOption types.rawLua ''
      This function runs when first opening a new note.

      The `entry` arg is a table containing all the information about the entry (see above
      `data_tbl_schema`).

      This example is meant to be used with the `markdown` filetype.
      The function must return a set of lines, specifying the lines to be added to the note.
    '';

    format_references = mkNullOrOption types.rawLua ''
      This function runs when inserting a formatted reference (currently by `f/c-f` in Telescope).

      It works similarly to the `format_notes` above, except that the set of lines should only
      contain one line (references using multiple lines aren't currently supported).
    '';
  };

  papis-storage = {
    key_name_conversions =
      defaultNullOpts.mkAttrsOf types.str
        {
          time_added = "time-added";
        }
        ''
          As lua doesn't deal well with '-', we define conversions between the format
          in the `info.yaml` and the format in papis.nvim's internal database.
        '';

    tag_format = defaultNullOpts.mkEnum' {
      values = [
        "tbl"
        ","
        ":"
        " "
      ];
      pluginDefault = null;
      example = "tbl";
      description = ''
        The format used for tags.
        Will be determined automatically if left empty.

        Can be set to:
        - `"tbl"` if a lua table,
        - `","` if comma-separated,
        - `":"` if semi-colon separated,
        - `" "` if space separated.
      '';
    };

    required_keys = defaultNullOpts.mkListOf types.str [ "papis_id" "ref" ] ''
      The keys which `.yaml` files are expected to always define.

      Files that are missing these keys will cause an error message and will not be added to the
      database.
    '';
  };
}
