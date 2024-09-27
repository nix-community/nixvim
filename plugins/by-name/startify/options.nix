{ lib, helpers }:
with lib;
{
  session_dir = helpers.defaultNullOpts.mkStr "~/.vim/session" ''
    The directory to save/load sessions to/from.
  '';

  lists = mkOption {
    type =
      with lib.types;
      listOf (
        either strLua (submodule {
          freeformType = with types; attrsOf anything;
          options = {
            type = mkOption {
              type = types.str;
              description = "The type of the list";
              example = "files";
            };

            header = helpers.mkNullOrOption (with lib.types; listOf (maybeRaw str)) ''
              The 'header' is a list of strings, whereas each string will be put on its own
              line in the header.
            '';

            indices = helpers.mkNullOrOption (with lib.types; listOf (maybeRaw str)) ''
              The 'indices' is a list of strings, which act as indices for the current list.
              Opposed to the global `custom_indices`, this is limited to the current list.
            '';
          };
        })
      );
    apply = v: map (listElem: if isString listElem then helpers.mkRaw listElem else listElem) v;
    default = [ ];
    description = ''
      Startify displays lists. Each list consists of a `type` and optionally a `header` and
      custom `indices`.

      Default:
      ```nix
        [
          {
            type = "files";
            header = ["   MRU"];
          }
          {
            type = "dir";
            header = [{__raw = "'   MRU' .. vim.loop.cwd()";}];
          }
          {
            type = "sessions";
            header = ["   Sessions"];
          }
          {
            type = "bookmarks";
            header = ["   Bookmarks"];
          }
          {
            type = "commands";
            header = ["   Commands"];
          }
        ]
      ```
    '';
  };

  bookmarks =
    helpers.defaultNullOpts.mkListOf
      (
        with lib.types;
        oneOf [
          str
          rawLua
          attrs
        ]
      )
      [ ]
      ''
        A list of files or directories to bookmark.
        The list can contain two kinds of types.
        Either a path (str) or an attrs where the key is the custom index and the value is the path.
      '';

  commands =
    helpers.defaultNullOpts.mkListOf
      (
        with types;
        oneOf [
          str
          (attrsOf (either str (listOf str)))
          (listOf str)
        ]
      )
      [ ]
      ''
        A list of commands to execute on selection.
        Leading colons are optional.
        It supports optional custom indices and/or command descriptions.

        Example:
        ```nix
          [
            ":help reference"
            ["Vim Reference" "h ref"]
            {h = "h ref";}
            {m = ["My magical function" "call Magic()"];}
          ]
        ```
      '';

  files_number = helpers.defaultNullOpts.mkUnsignedInt 10 ''
    The number of files to list.
  '';

  update_oldfiles = helpers.defaultNullOpts.mkBool false ''
    Usually `|v:oldfiles|` only gets updated when Vim exits.
    Using this option updates it on-the-fly, so that `:Startify` is always up-to-date.
  '';

  session_autoload = helpers.defaultNullOpts.mkBool false ''
    If this option is enabled and you start Vim in a directory that contains a `Session.vim`,
    that session will be loaded automatically.
    Otherwise it will be shown as the top entry in the Startify buffer.

    The same happens when you `|:cd|` to a directory that contains a `Session.vim` and execute
    `|:Startify|`.

    It also works if you open a bookmarked directory. See the `bookmarks` option.

    This is great way to create a portable project folder!

    NOTE: This option is affected by `session_delete_buffers`.
  '';

  session_before_save = helpers.defaultNullOpts.mkListOf types.str [ ] ''
    This is a list of commands to be executed before saving a session.

    Example: `["silent! tabdo NERDTreeClose"]`
  '';

  session_persistence = helpers.defaultNullOpts.mkBool false ''
    Automatically update sessions in two cases:
    - Before leaving Vim
    - Before loading a new session via `:SLoad`
  '';

  session_delete_buffers = helpers.defaultNullOpts.mkBool true ''
    Delete all buffers when loading or closing a session:
    - When using `|startify-:SLoad|`.
    - When using `|startify-:SClose|`.
    - When using `session_autoload`.
    - When choosing a session from the Startify buffer.

    NOTE: Buffers with unsaved changes are silently ignored.
  '';

  change_to_dir = helpers.defaultNullOpts.mkBool true ''
    When opening a file or bookmark, change to its directory.

    You want to disable this, if you're using `|'autochdir'|` as well.

    NOTE: It defaults to `true`, because that was already the behaviour at the time this option was
    introduced.
  '';

  change_to_vcs_root = helpers.defaultNullOpts.mkBool false ''
    When opening a file or bookmark, seek and change to the root directory of the VCS (if there is
    one).

    At the moment only git, hg, bzr and svn are supported.
  '';

  change_cmd = helpers.defaultNullOpts.mkStr "lcd" ''
    The default command for switching directories.

    Valid values:
    - `cd`
    - `lcd`
    - `tcd`

    Affects `change_to_dir` and `change_to_vcs_root`.
  '';

  skiplist = helpers.defaultNullOpts.mkListOf types.str [ ] ''
    A list of Vim regular expressions that is used to filter recently used files.
    See `|pattern.txt|` for what patterns can be used.

    The following patterns are filtered by default:
    - `'runtime/doc/.*\.txt$'`
    - `'bundle/.*/doc/.*\.txt$'`
    - `'plugged/.*/doc/.*\.txt$'`
    - `'/.git/'`
    - `'fugitiveblame$'`
    - `escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc/.*\.txt$'`

    NOTE: Due to the nature of patterns, you can't just use "~/mysecret" but have to use
    "$HOME .'/mysecret.txt'".
    The former would do something entirely different: `|/\~|`.

    NOTE: When using backslashes as path separators, escape them. Otherwise using
    "C:\this\vim\path\is\problematic" would not match what you would expect, since `|/\v|` is a
    pattern, too.

    Example:
    ```nix
      [
       "\.vimgolf"
       "^/tmp"
       "/project/.*/documentation"
      ]
    ```
  '';

  fortune_use_unicode = helpers.defaultNullOpts.mkBool false ''
    By default, the fortune header uses ASCII characters, because they work for everyone.
    If you set this option to `true` and your 'encoding' is "utf-8", Unicode box-drawing characters
    will be used instead.

    This is not the default, because users of East Asian languages often set 'ambiwidth' to "double"
    or make their terminal emulator treat characters of ambiguous width as double width.
    Both would make the drawn box look funny.

    For more information: http://unicode.org/reports/tr11
  '';

  padding_left = helpers.defaultNullOpts.mkUnsignedInt 3 ''
    The number of spaces used for left padding.
  '';

  skiplist_server = helpers.defaultNullOpts.mkListOf (with lib.types; maybeRaw str) [ ] ''
    Do not create the startify buffer, if this is a Vim server instance with a name contained in
    this list.

    Example: `["GVIM"]`
  '';

  enable_special = helpers.defaultNullOpts.mkBool true ''
    Show `<empty buffer>` and `<quit>`.
  '';

  enable_unsafe = helpers.defaultNullOpts.mkBool false ''
    Enable the option only in case you think Vim starts too slowly (because of `:Startify`) or if
    you often edit files on remote filesystems.

    It's called unsafe because it improves the time `:Startify` needs to execute by reducing the
    amount of syscalls to the underlying operating system, but sacrifices the precision of shown
    entries.

    This could lead to inconsistences in the shown `:Startify` entries (e.g. the same file could be
    shown twice, because one time file was opened via absolute path and another time via symlink).

    Currently this option does this:
    - don't resolves symlinks (`readlink(2)`)
    - don't check every file if it's readable (`stat(2)`)
    - don't filter through the bookmark list
  '';

  session_remove_lines = helpers.defaultNullOpts.mkListOf types.str [ ] ''
    Lines matching any of the patterns in this list, will be removed from the session file.

    Example:
    ```nix
      ["setlocal" "winheight"]
    ```
    Internally this simply does:
    - `:global/setlocal/delete`
    - `:global/winheight/delete`

    So you can use any `|pattern|`.

    NOTE: Take care not to mess up any expressions within the session file, otherwise you'll
    probably get problems when trying to load it.
  '';

  session_savevars = helpers.defaultNullOpts.mkListOf types.str [ ] ''
    Include a list of variables in here which you would like Startify to save into the session file
    in addition to what Vim normally saves into the session file.

    Example:
    ```nix
      [
       "g:startify_session_savevars"
       "g:startify_session_savecmds"
       "g:random_plugin_use_feature"
      ]
    ```
  '';

  session_savecmds = helpers.defaultNullOpts.mkListOf types.str [ ] ''
    Include a list of cmdline commands which Vim will run upon loading the session.

    Example:
    ```nix
      [
        "silent !pdfreader ~/latexproject/main.pdf &"
      ]
    ```
  '';

  session_number = helpers.defaultNullOpts.mkUnsignedInt 999 ''
    The maximum number of sessions to display.
    Makes the most sense together with `session_sort`.
  '';

  session_sort = helpers.defaultNullOpts.mkBool false ''
    Sort sessions by modification time (when the session files were written) rather than
    alphabetically.
  '';

  custom_indices = helpers.defaultNullOpts.mkListOf' {
    type = types.str;
    pluginDefault = [ ];
    description = ''
      Use any list of strings as indices instead of increasing numbers. If there are more startify
      entries than actual items in the custom list, the remaining entries will be filled using the
      default numbering scheme starting from 0.

      Thus you can create your own indexing scheme that fits your keyboard layout.
      You don't want to leave the home row, do you?!
    '';
    example = [
      "f"
      "g"
      "h"
    ];
  };

  custom_header = helpers.defaultNullOpts.mkListOf' {
    type = types.str;
    description = ''
      Define your own header.

      This option takes a `list of strings`, whereas each string will be put on its own line.
      If it is a simple `string`, it should evaluate to a list of strings.
    '';
    example = [
      ""
      "     ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
      "     ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
      "     ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
      "     ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
      "     ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
      "     ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
    ];
  };

  custom_header_quotes = helpers.defaultNullOpts.mkListOf' {
    type = with types; listOf str;
    pluginDefault = [ ];
    description = ''
      If you don't set `custom_header`, the internal cowsay implementation with
      predefined random quotes will be used.

      To use your own quotes, set this option to a list of quotes. Each quote is
      either another list or a `|Funcref|` (see `|expr-lambda|`) that returns a list.
    '';
    example = [
      [ "quote #1" ]
      [
        "quote #2"
        "using"
        "three lines"
      ]
    ];
  };

  custom_footer = helpers.defaultNullOpts.mkListOf' {
    type = types.str;
    description = ''
      Same as the custom header, but shown at the bottom of the startify buffer.
    '';
  };

  disable_at_vimenter = helpers.defaultNullOpts.mkBool false ''
    Don't run Startify at Vim startup.
    You can still call it anytime via `:Startify`.
  '';

  relative_path = helpers.defaultNullOpts.mkBool false ''
    If the file is in or below the current working directory, use a relative path.
    Otherwise an absolute path is used.
    The latter prevents hard to grasp entries like `../../../../../foo`.

    NOTE: This only applies to the "files" list, since the "dir" list is relative by nature.
  '';

  use_env = helpers.defaultNullOpts.mkBool false ''
    Show environment variables in path, if their name is shorter than their value.
    See `|startify-colors|` for highlighting them.

    `$PWD` and `$OLDPWD` are ignored.
  '';
}
