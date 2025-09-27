{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts mkNullOrStr;
  inherit (lib) types;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "floaterm";
  package = "vim-floaterm";
  globalPrefix = "floaterm_";
  description = "A Neovim plugin for floating terminal windows.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO: Added 2024-12-16; remove after 25.05
  optionsRenamedToSettings = [
    "autoclose"
    "autohide"
    "autoinsert"
    "borderchars"
    "giteditor"
    "height"
    "opener"
    "position"
    "rootmarkers"
    "shell"
    "title"
    "width"
    "wintype"
  ]
  ++
    map
      (name: {
        old = [
          "keymaps"
          name
        ];
        new = "keymap_${name}";
      })
      [
        "first"
        "hide"
        "kill"
        "last"
        "new"
        "next"
        "prev"
        "show"
        "toggle"
      ];

  settingsOptions = {
    shell = mkNullOrStr ''
      Which shell should floaterm use.
      Default value is the same as your `shell` option.
    '';

    title = defaultNullOpts.mkStr "floaterm: $1/$2" ''
      Title format in the floating/popup terminal window.
      If empty, the title won't be show.
    '';

    wintype = defaultNullOpts.mkStr "float" ''
      Set it to `"split"` or `"vsplit"` if you don't want to use floating or popup window.
    '';

    width =
      defaultNullOpts.mkNullable (with types; either ints.unsigned (numbers.between 0.0 1.0)) 0.6
        ''
          Width of the floaterm window.
          It can be either an integer (number of columns) or a float between `0.0` and `1.0`.
          In this case, the width is relative to `columns`.
        '';

    height =
      defaultNullOpts.mkNullable (with types; either ints.unsigned (numbers.between 0.0 1.0)) 0.6
        ''
          Width of the floaterm window.
          It can be either an integer (number of lines) or a float between `0.0` and `1.0`.
          In this case, the width is relative to `lines`.
        '';

    position = mkNullOrStr ''
      The position of the floaterm window.

      It's recommended to have a look at those options meanings, e.g. `:help :leftabove`.

      - If `wintype` is `"split"` or `"vsplit"`:
        - `"leftabove"`
        - `"aboveleft"`
        - `"rightbelow"`
        - `"belowright"`
        - `"topleft"`
        - `"botright"` (default)
      - If `wintype` is `"float"`:
        - `"top"`
        - `"bottom"`
        - `"left"`
        - `"right"`
        - `"topleft"`
        - `"topright"`
        - `"bottomleft"`
        - `"bottomright"`
        - `"center"` (default)
        - `"auto"` (at the cursor place)
    '';

    borderchars = defaultNullOpts.mkStr "─│─│┌┐┘└" ''
      8 characters of the floating window border (top, right, bottom, left, topleft, topright,
      botright, botleft).
    '';

    rootmarkers =
      defaultNullOpts.mkListOf types.str
        [
          ".project"
          ".git"
          ".hg"
          ".svn"
          ".root"
        ]
        ''
          Markers used to detect the project root directory when running.
          ```
          :FloatermNew --cwd=<root>
          ```
        '';

    opener = defaultNullOpts.mkStr "split" ''
      Command used for opening a file in the outside nvim from within `:terminal`.

      Available: `"edit"`, `"split"`, `"vsplit"`, `"tabe"`, `"drop"` or user-defined commands.
    '';

    autoclose = defaultNullOpts.mkEnum [ 0 1 2 ] 1 ''
      Whether to close floaterm window once a job gets finished.

      - `0` - Always do NOT close floaterm window.
      - `1` - Close window only if the job exits normally
      - `2` - Always close floaterm window.
    '';

    autohide = defaultNullOpts.mkEnum [ 0 1 2 ] 1 ''
      Whether to hide previous floaterms before switching to or opening a another
      one.

      - `0` - Always do NOT hide previous floaterm windows
      - `1` - Only hide those whose position (`b:floaterm_position`) is identical to that of the
        floaterm which will be opened
      - `2` - Always hide them
    '';

    autoinsert = defaultNullOpts.mkBool true ''
      	Whether to enter `|Terminal-mode|` after opening a floaterm.
    '';

    titleposition = defaultNullOpts.mkEnumFirstDefault [ "left" "center" "right" ] ''
      The position of the floaterm title.
    '';

    giteditor = defaultNullOpts.mkBool true ''
      Whether to override $GIT_EDITOR in floaterm terminals so git commands can open open an
      editor in the same neovim instance.
    '';

    keymap_new = defaultNullOpts.mkStr' {
      pluginDefault = "";
      description = ''
        Keyboard shortcut to open the floaterm window.
      '';
      example = "<F7>";
    };

    keymap_prev = defaultNullOpts.mkStr' {
      pluginDefault = "";
      description = ''
        Keyboard shortcut to navigate to the previous terminal.
      '';
      example = "<F8>";
    };

    keymap_next = defaultNullOpts.mkStr' {
      pluginDefault = "";
      description = ''
        Keyboard shortcut to navigate to the next terminal.
      '';
      example = "<F9>";
    };

    keymap_first = defaultNullOpts.mkStr "" ''
      Keyboard shortcut to navigate to the first terminal.
    '';

    keymap_last = defaultNullOpts.mkStr "" ''
      Keyboard shortcut to navigate to the last terminal.
    '';

    keymap_hide = defaultNullOpts.mkStr "" ''
      Keyboard shortcut to hide the floaterm window.
    '';

    keymap_show = defaultNullOpts.mkStr "" ''
      Keyboard shortcut to show the floaterm window.
    '';

    keymap_kill = defaultNullOpts.mkStr "" ''
      Keyboard shortcut to kill the floaterm window.
    '';

    keymap_toggle = defaultNullOpts.mkStr' {
      pluginDefault = "";
      description = ''
        Keyboard shortcut to toggle the floaterm window.
      '';
      example = "<F12>";
    };
  };

  settingsExample = {
    width = 0.9;
    height = 0.9;
    opener = "edit ";
    title = "";
    rootmarkers = [
      "build/CMakeFiles"
      ".project"
      ".git"
      ".hg"
      ".svn"
      ".root"
    ];
    keymap_new = "<Leader>ft";
    keymap_prev = "<Leader>fp";
    keymap_next = "<Leader>fn";
    keymap_toggle = "<Leader>t";
    keymap_kill = "<Leader>fk";
  };
}
