{ lib, helpers }:
with lib;
{
  signs =
    let
      signOptions = defaults: {
        text = helpers.defaultNullOpts.mkStr defaults.text ''
          Specifies the character to use for the sign.
        '';

        show_count = helpers.defaultNullOpts.mkBool false ''
          Showing count of hunk, e.g. number of deleted lines.
        '';
      };
    in
    {
      add = signOptions {
        hl = "GitSignsAdd";
        text = "┃";
        numhl = "GitSignsAddNr";
        linehl = "GitSignsAddLn";
      };
      change = signOptions {
        hl = "GitSignsChange";
        text = "┃";
        numhl = "GitSignsChangeNr";
        linehl = "GitSignsChangeLn";
      };
      delete = signOptions {
        hl = "GitSignsDelete";
        text = "▁";
        numhl = "GitSignsDeleteNr";
        linehl = "GitSignsDeleteLn";
      };
      topdelete = signOptions {
        hl = "GitSignsDelete";
        text = "▔";
        numhl = "GitSignsDeleteNr";
        linehl = "GitSignsDeleteLn";
      };
      changedelete = signOptions {
        hl = "GitSignsChange";
        text = "~";
        numhl = "GitSignsChangeNr";
        linehl = "GitSignsChangeLn";
      };
      untracked = signOptions {
        hl = "GitSignsAdd";
        text = "┆";
        numhl = "GitSignsAddNr";
        linehl = "GitSignsAddLn";
      };
    };

  worktrees =
    let
      worktreeType = types.submodule {
        freeformType = with types; attrsOf anything;
        options = {
          toplevel = mkOption {
            type = with lib.types; maybeRaw str;
            description = ''
              Path to the top-level of the parent git repository.
            '';
          };

          gitdir = mkOption {
            type = with lib.types; maybeRaw str;
            description = ''
              Path to the git directory of the parent git repository (typically the `.git/` directory).
            '';
          };
        };
      };
    in
    helpers.mkNullOrOption (types.listOf worktreeType) ''
      Detached working trees.
      If normal attaching fails, then each entry in the table is attempted with the work tree
      details set.
    '';

  on_attach = helpers.mkNullOrLuaFn ''
    Callback called when attaching to a buffer. Mainly used to setup keymaps
    when `config.keymaps` is empty. The buffer number is passed as the first
    argument.

    This callback can return `false` to prevent attaching to the buffer.

    Example:
    ```lua
      function(bufnr)
        if vim.api.nvim_buf_get_name(bufnr):match(<PATTERN>) then
          -- Don't attach to specific buffers whose name matches a pattern
          return false
        end
        -- Setup keymaps
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'hs', '<cmd>lua require"gitsigns".stage_hunk()<CR>', {})
        ... -- More keymaps
      end
    ```
  '';

  watch_gitdir = {
    enable = helpers.defaultNullOpts.mkBool true ''
      When opening a file, a `libuv` watcher is placed on the respective `.git` directory to detect
      when changes happen to use as a trigger to update signs.
    '';

    follow_files = helpers.defaultNullOpts.mkBool true ''
      If a file is moved with `git mv`, switch the buffer to the new location.
    '';
  };

  sign_priority = helpers.defaultNullOpts.mkUnsignedInt 6 ''
    Priority to use for signs.
  '';

  signcolumn = helpers.defaultNullOpts.mkBool true ''
    Enable/disable symbols in the sign column.

    When enabled the highlights defined in `signs.*.hl` and symbols defined in `signs.*.text` are
    used.
  '';

  numhl = helpers.defaultNullOpts.mkBool false ''
    Enable/disable line number highlights.

    When enabled the highlights defined in `signs.*.numhl` are used.
    If the highlight group does not exist, then it is automatically defined and linked to the
    corresponding highlight group in `signs.*.hl`.
  '';

  linehl = helpers.defaultNullOpts.mkBool false ''
    Enable/disable line highlights.

    When enabled the highlights defined in `signs.*.linehl` are used.
    If the highlight group does not exist, then it is automatically defined and linked to the
    corresponding highlight group in `signs.*.hl`.
  '';

  show_deleted = helpers.defaultNullOpts.mkBool false ''
    Show the old version of hunks inline in the buffer (via virtual lines).

    Note: Virtual lines currently use the highlight `GitSignsDeleteVirtLn`.
  '';

  diff_opts =
    let
      diffOptType = types.submodule {
        freeformType = with types; attrsOf anything;
        options = {
          algorithm =
            helpers.defaultNullOpts.mkEnumFirstDefault
              [
                "myers"
                "minimal"
                "patience"
                "histogram"
              ]
              ''
                Diff algorithm to use. Values:
                - "myers"      the default algorithm
                - "minimal"    spend extra time to generate the smallest possible diff
                - "patience"   patience diff algorithm
                - "histogram"  histogram diff algorithm
              '';

          internal = helpers.defaultNullOpts.mkBool false ''
            Use Neovim's built in `xdiff` library for running diffs.
          '';

          indent_heuristic = helpers.defaultNullOpts.mkBool false ''
            Use the indent heuristic for the internal diff library.
          '';

          vertical = helpers.defaultNullOpts.mkBool true ''
            Start diff mode with vertical splits.
          '';

          linematch = helpers.mkNullOrOption types.int ''
            Enable second-stage diff on hunks to align lines.
            Requires `internal=true`.
          '';

          ignore_blank_lines = helpers.defaultNullOpts.mkBool true ''
            Ignore changes where lines are blank.
          '';

          ignore_whitespace_change = helpers.defaultNullOpts.mkBool true ''
            Ignore changes in amount of white space.
            It should ignore adding trailing white space, but not leading white space.
          '';

          ignore_whitespace = helpers.defaultNullOpts.mkBool true ''
            Ignore all white space changes.
          '';

          ignore_whitespace_change_at_eol = helpers.defaultNullOpts.mkBool true ''
            Ignore white space changes at end of line.
          '';
        };
      };
    in
    helpers.mkNullOrOption diffOptType ''
      Diff options.
      If set to null they are derived from the vim `diffopt`.
    '';

  base = helpers.mkNullOrOption types.str ''
    The object/revision to diff against.
    See `|gitsigns-revision|`.
  '';

  count_chars =
    helpers.defaultNullOpts.mkAttrsOf types.str
      {
        "__unkeyed_1" = "1";
        "__unkeyed_2" = "2";
        "__unkeyed_3" = "3";
        "__unkeyed_4" = "4";
        "__unkeyed_5" = "5";
        "__unkeyed_6" = "6";
        "__unkeyed_7" = "7";
        "__unkeyed_8" = "8";
        "__unkeyed_9" = "9";
        "+" = ">";
      }
      ''
        The count characters used when `signs.*.show_count` is enabled.
        The `+` entry is used as a fallback. With the default, any count outside of 1-9 uses the `>`
        character in the sign.

        Possible use cases for this field:
        - to specify unicode characters for the counts instead of 1-9.
        - to define characters to be used for counts greater than 9.
      '';

  status_formatter = helpers.defaultNullOpts.mkLuaFn ''
    function(status)
      local added, changed, removed = status.added, status.changed, status.removed
      local status_txt = {}
      if added and added > 0 then
        table.insert(status_txt, '+' .. added)
      end
      if changed and changed > 0 then
        table.insert(status_txt, '~' .. changed)
      end
      if removed and removed > 0 then
        table.insert(status_txt, '-' .. removed)
      end
      return table.concat(status_txt, ' ')
    end
  '' "Function used to format `b:gitsigns_status`.";

  max_file_length = helpers.defaultNullOpts.mkUnsignedInt 40000 ''
    Max file length (in lines) to attach to.
  '';

  preview_config =
    helpers.defaultNullOpts.mkAttrsOf types.anything
      {
        border = "single";
        style = "minimal";
        relative = "cursor";
        row = 0;
        col = 1;
      }
      ''
        Option overrides for the Gitsigns preview window.
        Table is passed directly to `nvim_open_win`.
      '';

  auto_attach = helpers.defaultNullOpts.mkBool true ''
    Automatically attach to files.
  '';

  attach_to_untracked = helpers.defaultNullOpts.mkBool true ''
    Attach to untracked files.
  '';

  update_debounce = helpers.defaultNullOpts.mkUnsignedInt 100 ''
    Debounce time for updates (in milliseconds).
  '';

  current_line_blame = helpers.defaultNullOpts.mkBool false ''
    Adds an unobtrusive and customisable blame annotation at the end of the current line.
    The highlight group used for the text is `GitSignsCurrentLineBlame`.
  '';

  current_line_blame_opts = {
    virt_text = helpers.defaultNullOpts.mkBool true ''
      Whether to show a virtual text blame annotation
    '';

    virt_text_pos =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "eol"
          "overlay"
          "right_align"
        ]
        ''
          Blame annotation position.

          Available values:
          - `eol`         Right after eol character.
          - `overlay`     Display over the specified column, without shifting the underlying text.
          - `right_align` Display right aligned in the window.
        '';

    delay = helpers.defaultNullOpts.mkUnsignedInt 1000 ''
      Sets the delay (in milliseconds) before blame virtual text is displayed.
    '';

    ignore_whitespace = helpers.defaultNullOpts.mkBool false ''
      Ignore whitespace when running blame.
    '';

    virt_text_priority = helpers.defaultNullOpts.mkUnsignedInt 100 ''
      Priority of virtual text.
    '';
  };

  current_line_blame_formatter = helpers.defaultNullOpts.mkStr " <author>, <author_time> - <summary> " ''
    String or function used to format the virtual text of `current_line_blame`.

    When a string, accepts the following format specifiers:
    - `<abbrev_sha>`
    - `<orig_lnum>`
    - `<final_lnum>`
    - `<author>`
    - `<author_mail>`
    - `<author_time>` or `<author_time:FORMAT>`
    - `<author_tz>`
    - `<committer>`
    - `<committer_mail>`
    - `<committer_time>` or `<committer_time:FORMAT>`
    - `<committer_tz>`
    - `<summary>`
    - `<previous>`
    - `<filename>`

    For `<author_time:FORMAT>` and `<committer_time:FORMAT>`, `FORMAT` can be any valid date
    format that is accepted by `os.date()` with the addition of `%R` (defaults to `%Y-%m-%d`):
    - `%a`  abbreviated weekday name (e.g., Wed)
    - `%A`  full weekday name (e.g., Wednesday)
    - `%b`  abbreviated month name (e.g., Sep)
    - `%B`  full month name (e.g., September)
    - `%c`  date and time (e.g., 09/16/98 23:48:10)
    - `%d`  day of the month (16) [01-31]
    - `%H`  hour, using a 24-hour clock (23) [00-23]
    - `%I`  hour, using a 12-hour clock (11) [01-12]
    - `%M`  minute (48) [00-59]
    - `%m`  month (09) [01-12]
    - `%p`  either "am" or "pm" (pm)
    - `%S`  second (10) [00-61]
    - `%w`  weekday (3) [0-6 = Sunday-Saturday]
    - `%x`  date (e.g., 09/16/98)
    - `%X`  time (e.g., 23:48:10)
    - `%Y`  full year (1998)
    - `%y`  two-digit year (98) [00-99]
    - `%%`  the character `%´
    - `%R`  relative (e.g., 4 months ago)

    When a function:

    Parameters:
      - `{name}`        Git user name returned from `git config user.name`
      - `{blame_info}`  Table with the following keys:
        - `abbrev_sha`: string
        - `orig_lnum`: integer
        - `final_lnum`: integer
        - `author`: string
        - `author_mail`: string
        - `author_time`: integer
        - `author_tz`: string
        - `committer`: string
        - `committer_mail`: string
        - `committer_time`: integer
        - `committer_tz`: string
        - `summary`: string
        - `previous`: string
        - `filename`: string
        - `boundary`: true?

      Note that the keys map onto the output of:
        `git blame --line-porcelain`

    Return:
      The result of this function is passed directly to the `opts.virt_text` field of
      `|nvim_buf_set_extmark|` and thus must be a list of `[text, highlight]` tuples.
  '';

  current_line_blame_formatter_nc = helpers.defaultNullOpts.mkStr " <author>" ''
    String or function used to format the virtual text of `|gitsigns-config-current_line_blame|`
    for lines that aren't committed.

    See `|gitsigns-config-current_line_blame_formatter|` for more information.
  '';

  trouble = helpers.mkNullOrOption types.bool ''
    When using setqflist() or setloclist(), open Trouble instead of the
    quickfix/location list window.

    Default: `pcall(require, 'trouble')`
  '';

  word_diff = helpers.defaultNullOpts.mkBool false ''
    Highlight intra-line word differences in the buffer.
    Requires `config.diff_opts.internal = true`.
  '';

  debug_mode = helpers.defaultNullOpts.mkBool false ''
    Enables debug logging and makes the following functions available: `dump_cache`,
    `debug_messages`, `clear_debug`.
  '';
}
