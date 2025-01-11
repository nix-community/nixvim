lib:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts mkNullOrStr;
in
{
  highlight_matches = defaultNullOpts.mkStr' {
    pluginDefault = "underline";
    example = "hi Search ctermfg=228 cterm=underline";
    description = ''
      Controls VM default highlighting style for patterns matched, but not selected.

      Possible useful values are `"underline"` and `"red"`.
      Otherwise an empty string if you want the normal `|Search|` highlight, or a full highlight
      command (help `|:hi|`).
    '';
  };

  set_statusline = defaultNullOpts.mkEnum [ 1 2 3 ] 2 ''
    Enable statusline when VM is active.
    - With a value of `1`, the statusline will be set once, on VM start.
    - With a value of `2`, the statusline will be refreshed on `|CursorHold|` event.
    - With a value of `3`, also on `|CursorMoved|` event.
  '';

  silent_exit = defaultNullOpts.mkFlagInt 0 ''
    Don't display a message when exiting VM.

    You may prefer it if you already set up statusline integration.
  '';

  quit_after_leaving_insert_mode = defaultNullOpts.mkFlagInt 0 ''
    So that you don't have to type `<Esc>` twice.

    If you set this to `1`, maybe you can remap `Reselect Last`, so that you can quickly restart VM
    with your last selection.
    See `|vm-quick-reference|`.
  '';

  add_cursor_at_pos_no_mappings = defaultNullOpts.mkFlagInt 0 ''
    When starting VM by adding a single cursor at position, don't enable buffer mappings, so that
    you can keep moving freely the cursor to add more cursors elsewhere.
  '';

  show_warnings = defaultNullOpts.mkFlagInt 1 ''
    When entering VM and there are mapping conflicts, a warning is displayed.

    Set to `0` to disable this warning.
    You can still run `|:VMDebug|` to see if there are conflicts.
  '';

  verbose_commands = defaultNullOpts.mkFlagInt 0 ''
    Set to `1` if you want command prompts to be more informative, rather than as minimal as
    possible.
  '';

  skip_shorter_lines = defaultNullOpts.mkFlagInt 1 ''
    When adding cursors up/down, skip shorter lines.
  '';

  skip_empty_lines = defaultNullOpts.mkFlagInt 0 ''
    When adding cursors up/down, skip empty lines.
  '';

  live_editing = defaultNullOpts.mkFlagInt 1 ''
    Controls how often text is updated in insert mode.
  '';

  reselect_first = defaultNullOpts.mkFlagInt 0 ''
    The first region will be reselected after most commands, if set to `1`.
  '';

  case_setting = defaultNullOpts.mkEnumFirstDefault [ "" "smart" "sensitive" "ignore" ] ''
    Starting case matching for patterns.
    Can be switched inside VM.
    Leave empty to use your current setting.
  '';

  disable_syntax_in_imode = defaultNullOpts.mkFlagInt 0 ''
    Whether to disable syntax highlighting in insert mode.

    You could want to do it for performance reasons.
  '';

  recursive_operations_at_cursors = defaultNullOpts.mkFlagInt 1 ''
    When executing normal commands in cursor mode (`dw` and similar), by default recursive mappings
    are used, so that user text object can be used as well.

    Set to `0` if you always want commands in cursor mode to be non-recursive.
  '';

  custom_remaps = defaultNullOpts.mkAttrsOf' {
    type = types.str;
    pluginDefault = { };
    example = {
      "<c-p>" = "N";
      "<c-s>" = "q";
    };
    description = ''
      To remap VM mappings to other VM mappings.
    '';
  };

  custom_noremaps = defaultNullOpts.mkAttrsOf' {
    type = types.str;
    pluginDefault = { };
    example = {
      "==" = "==";
      "<<" = "<<";
      ">>" = ">>";
    };
    description = ''
      To remap any key to normal! commands.
    '';
  };

  custom_motions = defaultNullOpts.mkAttrsOf' {
    type = types.str;
    pluginDefault = { };
    example = {
      h = "l";
      l = "h";
    };
    description = ''
      To remap any standard motion (`h`, `j`, `k`, `l`, `f`...) commands.

      It can be useful if you use keyboard layouts other than QWERTY.

      Valid motions that you can remap are:
      ```
      h j k l w W b B e E ge gE , ; $ 0 ^ % \| f F t T
      ```
    '';
  };

  user_operators = defaultNullOpts.mkListOf' {
    type = with types; either str (attrsOf ints.unsigned);
    pluginDefault = [ ];
    example = [
      "yd"
      "cx"
      { cs = 2; }
    ];
    description = ''
      Cursor mode only.

      The elements of the list can be simple strings (then any text object can be accepted) or an
      attrs with the operator as key, and the number of characters to be typed as value.

      These operators can be either vim or plugin operators, mappings are passed recursively.

      Note: `|vim-surround|` and `|vim-abolish|` have built-in support, this isn't needed for them
      to work.
    '';
  };

  use_first_cursor_in_line = defaultNullOpts.mkFlagInt 0 ''
    In insert mode, the active cursor is normally the last selected one.

    Set this option to `1` to always use the first cursor in the line.
  '';

  insert_special_keys = defaultNullOpts.mkListOf types.str [ "c-v" ] ''
    Some keys in insert mode can have a different behaviour, compared to vim
    defaults. Possible values:

    - `"c-a"`: `<C-A>` go to the beginning of the line, at indent level
    - `"c-e"`: `<C-E>` go to the end of the line
    - `"c-v"`: `<C-V>` paste from VM unnamed register
  '';

  single_mode_maps = defaultNullOpts.mkFlagInt 1 ''
    Set to `0` to disable entirely insert mode mappings to cycle cursors in `|vm-single-mode|`.

    If you only want to change the default mappings, see `|vm-mappings-buffer|`.
  '';

  single_mode_auto_reset = defaultNullOpts.mkFlagInt 1 ''
    If insert mode is entered while `|vm-single-mode|` is enabled, it will be reset automatically
    when exiting insert mode, unless this value is `0`.
  '';

  filesize_limit = defaultNullOpts.mkUnsignedInt 0 ''
    VM won't start if buffer size is greater than this.
  '';

  persistent_registers = defaultNullOpts.mkFlagInt 0 ''
    If true VM registers will be stored in the `|viminfo|`.
    The `viminfo` option must include `!`, for this to work.

    Also see `|:VMRegisters|`.
  '';

  reindent_filetypes = defaultNullOpts.mkListOf types.str [ ] ''
    Autoindentation (via `|indentkeys|`) is temporarily disabled in insert mode, and you have to
    reindent edited lines yoursef.

    For filetypes included in this list, edited lines are automatically reindented when exiting
    insert mode.
  '';

  plugins_compatibilty = defaultNullOpts.mkAttrsOf types.anything { } ''
    Used for plugins compatibility, see `|vm-compatibility|`.
  '';

  maps = defaultNullOpts.mkAttrsOf' {
    type = types.str;
    pluginDefault = { };
    example = {
      "Select All" = "<C-M-n>";
      "Add Cursor Down" = "<M-Down>";
      "Add Cursor Up" = "<M-Up>";
      "Mouse Cursor" = "<M-LeftMouse>";
      "Mouse Word" = "<M-RightMouse>";
    };
    description = ''
      Customize key mappings.
    '';
  };

  default_mappings = defaultNullOpts.mkFlagInt 1 ''
    Default mappings are `permanent`, that is, always available, and applied when Vim starts.

    Buffer mappings instead are applied per-buffer, when VM is started.
    Permanent mappings, except `<C-n>`, can be disabled by setting this option to `0`.
  '';

  mouse_mappings = defaultNullOpts.mkFlagInt 0 ''
    Whether to enable mouse mappings.
  '';

  leader = defaultNullOpts.mkNullable' {
    type =
      with types;
      either str (submodule {
        options = {
          default = mkNullOrStr ''
            Default leader.
          '';

          visual = mkNullOrStr ''
            Leader for the visual mappings.
          '';

          buffer = mkNullOrStr ''
            Leader for the buffer mappings.
          '';
        };
      });
    pluginDefault = ''\\'';
    example = {
      default = ''\'';
      visual = ''\'';
      buffer = "z";
    };
    description = ''
      Mappings preceded by `\\` are meant prefixed with `|g:VM_leader|`.

      Some of the permanent/visual mappings use the `|g:VM_leader|` as well, and you could want to
      use a different one for them.
      In this case you can define the leader as an attrs.
    '';
  };
}
