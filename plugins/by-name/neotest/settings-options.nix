{ lib }:
with lib;
let
  inherit (lib.nixvim) defaultNullOpts mkNullOrOption mkNullOrLuaFn;
in
{
  #################################################
  # CoreConfig

  discovery = {
    enabled = defaultNullOpts.mkBool true "Enable discovery.";

    concurrent = defaultNullOpts.mkUnsignedInt 0 ''
      Number of workers to parse files concurrently.
      0 automatically assigns number based on CPU.
      Set to 1 if experiencing lag.
    '';

    filter_dir = mkNullOrLuaFn ''
      `fun(name: string, rel_path: string, root: string): boolean`

      A function to filter directories when searching for test files.
      Receives the name, path relative to project root and project root path.
    '';
  };

  running = {
    concurrent = defaultNullOpts.mkBool true ''
      Run tests concurrently when an adapter provides multiple commands to run.
    '';
  };

  default_strategy = defaultNullOpts.mkStr "integrated" ''
    The default strategy.
  '';

  #################################################
  # Config

  log_level = defaultNullOpts.mkLogLevel "warn" ''
    Minimum log levels.
  '';

  consumers = defaultNullOpts.mkAttrsOf types.strLuaFn { } ''
    key: string
    value: lua function
  '';

  icons = defaultNullOpts.mkAttrsOf (with types; either str (listOf str)) {
    child_indent = "│";
    child_prefix = "├";
    collapsed = "─";
    expanded = "╮";
    failed = "";
    final_child_indent = " ";
    final_child_prefix = "╰";
    non_collapsible = "─";
    passed = "";
    running = "";
    running_animated = [
      "/"
      "|"
      "\\"
      "-"
      "/"
      "|"
      "\\"
      "-"
    ];
    skipped = "";
    unknown = "";
    watching = "";
  } "Icons used throughout the UI. Defaults use VSCode's codicons.";

  highlights = defaultNullOpts.mkAttrsOf types.str {
    adapter_name = "NeotestAdapterName";
    border = "NeotestBorder";
    dir = "NeotestDir";
    expand_marker = "NeotestExpandMarker";
    failed = "NeotestFailed";
    file = "NeotestFile";
    focused = "NeotestFocused";
    indent = "NeotestIndent";
    marked = "NeotestMarked";
    namespace = "NeotestNamespace";
    passed = "NeotestPassed";
    running = "NeotestRunning";
    select_win = "NeotestWinSelect";
    skipped = "NeotestSkipped";
    target = "NeotestTarget";
    test = "NeotestTest";
    unknown = "NeotestUnknown";
    watching = "NeotestWatching";
  } "";

  floating = {
    border = defaultNullOpts.mkStr "rounded" "Border style.";

    max_height = defaultNullOpts.mkProportion 0.6 ''
      Max height of window as proportion of NeoVim window.
    '';

    max_width = defaultNullOpts.mkProportion 0.6 ''
      Max width of window as proportion of NeoVim window.
    '';

    options = defaultNullOpts.mkAttrsOf types.anything { } ''
      Window local options to set on floating windows (e.g. winblend).
    '';
  };

  strategies = {
    integrated = {
      height = defaultNullOpts.mkUnsignedInt 40 ''
        height to pass to the pty running commands.
      '';

      width = defaultNullOpts.mkUnsignedInt 120 ''
        Width to pass to the pty running commands.
      '';
    };
  };

  summary = {
    enabled = defaultNullOpts.mkBool true "Whether to enable summary.";

    animated = defaultNullOpts.mkBool true "Enable/disable animation of icons.";

    follow = defaultNullOpts.mkBool true "Expand user's current file.";

    expandErrors = defaultNullOpts.mkBool true "Expand all failed positions.";

    mappings = defaultNullOpts.mkAttrsOf (with types; either str (listOf str)) {
      attach = "a";
      clear_marked = "M";
      clear_target = "T";
      debug = "d";
      debug_marked = "D";
      expand = [
        "<CR>"
        "<2-LeftMouse>"
      ];
      expand_all = "e";
      jumpto = "i";
      mark = "m";
      next_failed = "J";
      output = "o";
      prev_failed = "K";
      run = "r";
      run_marked = "R";
      short = "O";
      stop = "u";
      target = "t";
      watch = "w";
    } "Buffer mappings for summary window.";

    open = defaultNullOpts.mkStr "botright vsplit | vertical resize 50" ''
      A command or function to open a window for the summary.
      Either a string or a function that returns an integer.
    '';
  };

  output = {
    enabled = defaultNullOpts.mkBool true "Enable output.";

    open_on_run = defaultNullOpts.mkNullable (with types; either str bool) "short" ''
      Open nearest test result after running.
    '';
  };

  output_panel = {
    enabled = defaultNullOpts.mkBool true "Enable output panel.";

    open = defaultNullOpts.mkStr "botright split | resize 15" ''
      A command or function to open a window for the output panel.
      Either a string or a function that returns an integer.
    '';
  };

  quickfix = {
    enabled = defaultNullOpts.mkBool true "Enable quickfix.";

    open = defaultNullOpts.mkNullableWithRaw (with types; either bool str) false ''
      Set to true to open quickfix on startup, or a function to be called when the quickfix
      results are set.
    '';
  };

  status = {
    enabled = defaultNullOpts.mkBool true "Enable status.";

    virtual_text = defaultNullOpts.mkBool false "Display status using virtual text.";

    signs = defaultNullOpts.mkBool true "Display status using signs.";
  };

  state = {
    enabled = defaultNullOpts.mkBool true "Enable state.";
  };

  watch = {
    enabled = defaultNullOpts.mkBool true "Enable watch.";

    symbol_queries = mkNullOrOption (with types; attrsOf (maybeRaw str)) ''
      Treesitter queries or functions to capture symbols that are used for querying the LSP
      server for definitions to link files.
      If it is a function then the return value should be a list of node ranges.
    '';

    filter_path = mkNullOrLuaFn ''
      `(fun(path: string, root: string): boolean)`

      Returns whether the watcher should inspect a path for dependencies.
      Default ignores paths not under root or common package manager directories.
    '';
  };

  diagnostic = {
    enabled = defaultNullOpts.mkBool true "Enable diagnostic.";

    severity = defaultNullOpts.mkSeverity "error" ''
      Diagnostic severity, one of `vim.diagnostic.severity`.
    '';
  };
}
