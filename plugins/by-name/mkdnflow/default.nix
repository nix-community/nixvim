{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.mkdnflow;
in
{
  options.plugins.mkdnflow = lib.nixvim.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "mkdnflow.nvim";

    package = lib.mkPackageOption pkgs "mkdnflow.nvim" {
      default = [
        "vimPlugins"
        "mkdnflow-nvim"
      ];
    };

    modules =
      mapAttrs
        (
          moduleName: metadata:
          helpers.defaultNullOpts.mkBool metadata.default ''
            Enable module ${moduleName}.
            ${metadata.description}
          ''
        )
        {
          bib = {
            default = true;
            description = "Required for parsing bib files and following citations.";
          };
          buffers = {
            default = true;
            description = "Required for backward and forward navigation through buffers.";
          };
          conceal = {
            default = true;
            description = ''
              Required if you wish to enable link concealing.
              Note that you must declare `links.conceal` as `true` in addition to enabling this
              module if you wish to conceal links.
            '';
          };
          cursor = {
            default = true;
            description = "Required for jumping to links and headings; yanking anchor links.";
          };
          folds = {
            default = true;
            description = "Required for folding by section.";
          };
          links = {
            default = true;
            description = "Required for creating and destroying links and following links.";
          };
          lists = {
            default = true;
            description = "Required for manipulating lists, toggling to-do list items, etc.";
          };
          maps = {
            default = true;
            description = ''
              Required for setting mappings via the mappings table.
              Set to `false` if you wish to set mappings outside of the plugin.
            '';
          };
          paths = {
            default = true;
            description = "Required for link interpretation and following links.";
          };
          tables = {
            default = true;
            description = "Required for table navigation and formatting.";
          };
          yaml = {
            default = false;
            description = "Required for parsing yaml blocks.";
          };
        };

    filetypes =
      helpers.defaultNullOpts.mkAttrsOf types.bool
        {
          md = true;
          rmd = true;
          markdown = true;
        }
        ''
          A matching extension will enable the plugin's functionality for a file with that
          extension.

          NOTE: This functionality references the file's extension. It does not rely on
          Neovim's filetype recognition.
          The extension must be provided in lower case because the plugin converts file names to
          lowercase.
          Any arbitrary extension can be supplied.
          Setting an extension to `false` is the same as not including it in the list.
        '';

    createDirs = helpers.defaultNullOpts.mkBool true ''
      - `true`: Directories referenced in a link will be (recursively) created if they do not
        exist.
      - `false`: No action will be taken when directories referenced in a link do not exist.
        Neovim will open a new file, but you will get an error when you attempt to write the
        file.
    '';

    perspective = {
      priority =
        helpers.defaultNullOpts.mkEnumFirstDefault
          [
            "first"
            "current"
            "root"
          ]
          ''
            Specifies the priority perspective to take when interpreting link paths

            - `first` (default): Links will be interpreted relative to the first-opened file (when
              the current instance of Neovim was started)
            - `current`: Links will be interpreted relative to the current file
            - `root`: Links will be interpreted relative to the root directory of the current
              notebook (requires `perspective.root_tell` to be specified)
          '';

      fallback =
        helpers.defaultNullOpts.mkEnumFirstDefault
          [
            "first"
            "current"
            "root"
          ]
          ''
            Specifies the backup perspective to take if priority isn't possible (e.g. if it is
            `root` but no root directory is found).

            - `first` (default): Links will be interpreted relative to the first-opened file (when
              the current instance of Neovim was started)
            - `current`: Links will be interpreted relative to the current file
            - `root`: Links will be interpreted relative to the root directory of the current
              notebook (requires `perspective.root_tell` to be specified)
          '';

      rootTell = helpers.defaultNullOpts.mkNullable (with types; either (enum [ false ]) str) false ''
        - `<any file name>`: Any arbitrary filename by which the plugin can uniquely identify
          the root directory of the current notebook.
        - If `false` is used instead, the plugin will never search for a root directory, even
          if `perspective.priority` is set to `root`.
      '';

      nvimWdHeel = helpers.defaultNullOpts.mkBool false ''
        Specifies whether changes in perspective will result in corresponding changes to
        Neovim's working directory.

        - `true`: Changes in perspective will be reflected in the nvim working directory.
          (In other words, the working directory will "heel" to the plugin's perspective.)
          This helps ensure (at least) that path completions (if using a completion plugin with
          support for paths) will be accurate and usable.
        - `false` (default): Neovim's working directory will not be affected by Mkdnflow.
      '';

      update = helpers.defaultNullOpts.mkBool true ''
        Determines whether the plugin looks to determine if a followed link is in a different
        notebook/wiki than before.
        If it is, the perspective will be updated.
        Requires `rootTell` to be defined and `priority` to be `root`.

        - `true` (default): Perspective will be updated when following a link to a file in a
          separate notebook/wiki (or navigating backwards to a file in another notebook/wiki).
        - `false`: Perspective will be not updated when following a link to a file in a separate
          notebook/wiki.
          Under the hood, links in the file in the separate notebook/wiki will be interpreted
          relative to the original notebook/wiki.
      '';
    };

    wrap = helpers.defaultNullOpts.mkBool false ''
      - `true`: When jumping to next/previous links or headings, the cursor will continue
        searching at the beginning/end of the file.
      - `false`: When jumping to next/previous links or headings, the cursor will stop searching
        at the end/beginning of the file.
    '';

    bib = {
      defaultPath = helpers.mkNullOrOption types.str ''
        Specifies a path to a default `.bib` file to look for citation keys in (need not be in
        root directory of notebook).
      '';

      findInRoot = helpers.defaultNullOpts.mkBool true ''
        - `true`: When `perspective.priority` is also set to `root` (and a root directory was
          found), the plugin will search for bib files to reference in the notebook's top-level
          directory.
          If `bib.default_path` is also specified, the default path will be appended to the list
          of bib files found in the top level directory so that it will also be searched.
        - `false`: The notebook's root directory will not be searched for bib files.
      '';
    };

    silent = helpers.defaultNullOpts.mkBool false ''
      - `true`: The plugin will not display any messages in the console except compatibility
        warnings related to your config.
      - `false`: The plugin will display messages to the console (all messages from the plugin
        start with ⬇️ ).
    '';

    links = {
      style =
        helpers.defaultNullOpts.mkEnumFirstDefault
          [
            "markdown"
            "wiki"
          ]
          ''
            - `markdown`: Links will be expected in the standard markdown format:
              `[<title>](<source>)`
            - `wiki`: Links will be expected in the unofficial wiki-link style, specifically the
              title-after-pipe format (see https://github.com/jgm/pandoc/pull/7705):
              `[[<source>|<title>]]`.
          '';

      conceal = helpers.defaultNullOpts.mkBool false ''
        - `true`: Link sources and delimiters will be concealed (depending on which link style
          is selected)
        - `false`: Link sources and delimiters will not be concealed by mkdnflow
      '';

      context = helpers.defaultNullOpts.mkInt 0 ''
        - `0` (default): When following or jumping to links, assume that no link will be split
          over multiple lines
        - `n`: When following or jumping to links, consider `n` lines before and after a given
          line (useful if you ever permit links to be interrupted by a hard line break)
      '';

      implicitExtension = helpers.mkNullOrOption types.str ''
        A string that instructs the plugin (a) how to interpret links to files that do not have
        an extension, and (b) that new links should be created without an explicit extension.
      '';

      transformExplicit = helpers.defaultNullOpts.mkStrLuaFnOr (types.enum [ false ]) false ''
        A function that transforms the text to be inserted as the source/path of a link when a
        link is created.
        Anchor links are not currently customizable.
        If you want all link paths to be explicitly prefixed with the year, for instance, and
        for the path to be converted to uppercase, you could provide the following function
        under this key.
        (NOTE: The previous functionality specified under the `prefix` key has been migrated
        here to provide greater flexibility.)

        Example:
        ```lua
          function(input)
              return(string.upper(os.date('%Y-')..input))
          end
        ```
      '';

      transformImplicit =
        helpers.defaultNullOpts.mkStrLuaFnOr (types.enum [ false ])
          ''
            function(text)
                text = text:gsub(" ", "-")
                text = text:lower()
                text = os.date('%Y-%m-%d_')..text
                return(text)
            end
          ''
          ''
            A function that transforms the path of a link immediately before interpretation.
            It does not transform the actual text in the buffer but can be used to modify link
            interpretation.
            For instance, link paths that match a date pattern can be opened in a `journals`
            subdirectory of your notebook, and all others can be opened in a `pages` subdirectory,
            using the following function:

            ```lua
              function(input)
                  if input:match('%d%d%d%d%-%d%d%-%d%d') then
                      return('journals/'..input)
                  else
                      return('pages/'..input)
                  end
              end
            ```
          '';
    };

    toDo = {
      symbols =
        helpers.defaultNullOpts.mkListOf types.str
          [
            " "
            "-"
            "X"
          ]
          ''
            A list of symbols (each no more than one character) that represent to-do list completion
            statuses.
            `MkdnToggleToDo` references these when toggling the status of a to-do item.
            Three are expected: one representing not-yet-started to-dos (default: `' '`), one
            representing in-progress to-dos (default: `-`), and one representing complete to-dos
            (default: `X`).

            NOTE: Native Lua support for UTF-8 characters is limited, so in order to ensure all
            functionality works as intended if you are using non-ascii to-do symbols, you'll need to
            install the luarocks module "luautf8".
          '';

      updateParents = helpers.defaultNullOpts.mkBool true ''
        Whether parent to-dos' statuses should be updated based on child to-do status changes
        performed via `MkdnToggleToDo`

        - `true` (default): Parent to-do statuses will be inferred and automatically updated
          when a child to-do's status is changed
        - `false`: To-do items can be toggled, but parent to-do statuses (if any) will not be
          automatically changed
      '';

      notStarted = helpers.defaultNullOpts.mkStr " " ''
        This option can be used to stipulate which symbols shall be used when updating a parent
        to-do's status when a child to-do's status is changed.
        This is **not required**: if `toDo.symbols` is customized but this option is not
        provided, the plugin will attempt to infer what the meanings of the symbols in your list
        are by their order.

        For example, if you set `toDo.symbols` as `[" " "⧖" "✓"]`, `" "` will be assigned to
        `toDo.notStarted`, "⧖" will be assigned to `toDo.inProgress`, etc.
        If more than three symbols are specified, the first will be used as `notStarted`, the
        second will be used as `inProgress`, and the last will be used as `complete`.
        If two symbols are provided (e.g. `" ", "✓"`), the first will be used as both
        `notStarted` and `inProgress`, and the second will be used as `complete`.

        `toDo.notStarted` stipulates which symbol represents a not-yet-started to-do.
      '';

      inProgress = helpers.defaultNullOpts.mkStr "-" ''
        This option can be used to stipulate which symbols shall be used when updating a parent
        to-do's status when a child to-do's status is changed.
        This is **not required**: if `toDo.symbols` is customized but this option is not
        provided, the plugin will attempt to infer what the meanings of the symbols in your list
        are by their order.

        For example, if you set `toDo.symbols` as `[" " "⧖" "✓"]`, `" "` will be assigned to
        `toDo.notStarted`, "⧖" will be assigned to `toDo.inProgress`, etc.
        If more than three symbols are specified, the first will be used as `notStarted`, the
        second will be used as `inProgress`, and the last will be used as `complete`.
        If two symbols are provided (e.g. `" ", "✓"`), the first will be used as both
        `notStarted` and `inProgress`, and the second will be used as `complete`.

        `toDo.inProgress` stipulates which symbol represents an in-progress to-do.
      '';

      complete = helpers.defaultNullOpts.mkStr "X" ''
        This option can be used to stipulate which symbols shall be used when updating a parent
        to-do's status when a child to-do's status is changed.
        This is **not required**: if `toDo.symbols` is customized but this option is not
        provided, the plugin will attempt to infer what the meanings of the symbols in your list
        are by their order.

        For example, if you set `toDo.symbols` as `[" " "⧖" "✓"]`, `" "` will be assigned to
        `toDo.notStarted`, "⧖" will be assigned to `toDo.inProgress`, etc.
        If more than three symbols are specified, the first will be used as `notStarted`, the
        second will be used as `inProgress`, and the last will be used as `complete`.
        If two symbols are provided (e.g. `" ", "✓"`), the first will be used as both
        `notStarted` and `inProgress`, and the second will be used as `complete`.

        `toDo.complete` stipulates which symbol represents a complete to-do.
      '';
    };

    tables = {
      trimWhitespace = helpers.defaultNullOpts.mkBool true ''
        Whether extra whitespace should be trimmed from the end of a table cell when a table is
        formatted.
      '';

      formatOnMove = helpers.defaultNullOpts.mkBool true ''
        Whether tables should be formatted each time the cursor is moved via
        `MkdnTableNext/PrevCell` or `MkdnTableNext/Prev/Row`.
      '';

      autoExtendRows = helpers.defaultNullOpts.mkBool false ''
        Whether a new row should automatically be added to a table when `:MkdnTableNextRow` is
        triggered when the cursor is in the final row of the table.
        If `false`, the cursor will simply leave the table for the next line.
      '';

      autoExtendCols = helpers.defaultNullOpts.mkBool false ''
        Whether a new column should automatically be added to a table when `:MkdnTableNextCell`
        is triggered when the cursor is in the final column of the table.
        If false, the cursor will jump to the first cell of the next row, unless the cursor is
        already in the last row, in which case nothing will happen.
      '';
    };

    yaml = {
      bib = {
        override = helpers.defaultNullOpts.mkBool false ''
          Whether or not a bib path specified in a yaml block should be the only source
          considered for bib references in that file.
        '';
      };
    };

    mappings =
      helpers.defaultNullOpts.mkAttrsOf
        (
          with types;
          either (enum [ false ]) (submodule {
            options = {
              modes = mkOption {
                type = either str (listOf str);
                description = ''
                  Either a string or list representing the mode(s) that the mapping should apply
                  in.
                '';
                example = [
                  "n"
                  "v"
                ];
              };

              key = mkOption {
                type = str;
                description = "String representing the keymap.";
                example = "<Space>";
              };
            };
          })
        )
        {
          MkdnEnter = {
            modes = [
              "n"
              "v"
              "i"
            ];
            key = "<CR>";
          };
          MkdnTab = false;
          MkdnSTab = false;
          MkdnNextLink = {
            modes = "n";
            key = "<Tab>";
          };
          MkdnPrevLink = {
            modes = "n";
            key = "<S-Tab>";
          };
          MkdnNextHeading = {
            modes = "n";
            key = "]]";
          };
          MkdnPrevHeading = {
            modes = "n";
            key = "[[";
          };
          MkdnGoBack = {
            modes = "n";
            key = "<BS>";
          };
          MkdnGoForward = {
            modes = "n";
            key = "<Del>";
          };
          MkdnFollowLink = false; # see MkdnEnter
          MkdnCreateLink = false; # see MkdnEnter
          MkdnCreateLinkFromClipboard = {
            modes = [
              "n"
              "v"
            ];
            key = "<leader>p";
          }; # see MkdnEnter
          MkdnDestroyLink = {
            modes = "n";
            key = "<M-CR>";
          };
          MkdnMoveSource = {
            modes = "n";
            key = "<F2>";
          };
          MkdnYankAnchorLink = {
            modes = "n";
            key = "ya";
          };
          MkdnYankFileAnchorLink = {
            modes = "n";
            key = "yfa";
          };
          MkdnIncreaseHeading = {
            modes = "n";
            key = "+";
          };
          MkdnDecreaseHeading = {
            modes = "n";
            key = "-";
          };
          MkdnToggleToDo = {
            modes = [
              "n"
              "v"
            ];
            key = "<C-Space>";
          };
          MkdnNewListItem = false;
          MkdnNewListItemBelowInsert = {
            modes = "n";
            key = "o";
          };
          MkdnNewListItemAboveInsert = {
            modes = "n";
            key = "O";
          };
          MkdnExtendList = false;
          MkdnUpdateNumbering = {
            modes = "n";
            key = "<leader>nn";
          };
          MkdnTableNextCell = {
            modes = "i";
            key = "<Tab>";
          };
          MkdnTablePrevCell = {
            modes = "i";
            key = "<S-Tab>";
          };
          MkdnTableNextRow = false;
          MkdnTablePrevRow = {
            modes = "i";
            key = "<M-CR>";
          };
          MkdnTableNewRowBelow = {
            modes = "n";
            key = "<leader>ir";
          };
          MkdnTableNewRowAbove = {
            modes = "n";
            key = "<leader>iR";
          };
          MkdnTableNewColAfter = {
            modes = "n";
            key = "<leader>ic";
          };
          MkdnTableNewColBefore = {
            modes = "n";
            key = "<leader>iC";
          };
          MkdnFoldSection = {
            modes = "n";
            key = "<leader>f";
          };
          MkdnUnfoldSection = {
            modes = "n";
            key = "<leader>F";
          };
        }
        ''
          An attrs declaring the key mappings.
          The keys should be the name of a commands defined in
          `mkdnflow.nvim/plugin/mkdnflow.lua` (see `:h Mkdnflow-commands` for a list).
          Set to `false` to disable a mapping.
        '';
  };

  config =
    let
      setupOptions =
        with cfg;
        {
          modules = with modules; {
            inherit
              bib
              buffers
              conceal
              cursor
              folds
              links
              lists
              maps
              paths
              tables
              yaml
              ;
          };
          inherit filetypes;
          create_dirs = createDirs;
          perspective = with perspective; {
            inherit priority fallback;
            root_tell = rootTell;
            nvim_wd_heel = nvimWdHeel;
            inherit update;
          };
          inherit wrap;
          bib = with bib; {
            default_path = defaultPath;
            find_in_root = findInRoot;
          };
          inherit silent;
          links = with links; {
            inherit style conceal context;
            implicit_extension = implicitExtension;
            transform_implicit = transformImplicit;
            transform_explicit = transformExplicit;
          };
          to_do = with toDo; {
            inherit symbols;
            update_parents = updateParents;
            not_started = notStarted;
            in_progress = inProgress;
            inherit complete;
          };
          tables = with tables; {
            trim_whitespace = trimWhitespace;
            format_on_move = formatOnMove;
            auto_extend_rows = autoExtendRows;
            auto_extend_cols = autoExtendCols;
          };
          yaml = with yaml; {
            bib = with bib; {
              inherit override;
            };
          };
          mappings = helpers.ifNonNull' mappings (
            mapAttrs (
              action: options:
              if isBool options then
                options
              else
                [
                  options.modes
                  options.key
                ]
            ) mappings
          );
        }
        // cfg.extraOptions;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        require("mkdnflow").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
