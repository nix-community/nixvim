lib:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
{
  Height = defaultNullOpts.mkStr' {
    pluginDefault = "20%";
    example = "40";
    description = ''
      The part of the screen the split pane Vimux will spawn should take up.
      This option accepts both a number of lines/columns or a percentage.
    '';
  };

  Orientation = defaultNullOpts.mkEnumFirstDefault [ "v" "h" ] ''
    The default orientation of the split tmux pane.

    This tells tmux to make the pane either vertically or horizontally, which is backward from
    how Vim handles creating splits.
  '';

  UseNearest = defaultNullOpts.mkFlagInt 1 ''
    Use existing pane or window (not used by vim) if found instead of running `split-window`.
  '';

  ResetSequence = defaultNullOpts.mkStr' {
    pluginDefault = "C-u";
    example = "";
    description = ''
      The keys sent to the runner pane before running a command.

      When vimux runs a tmux command, it first makes sure that the runner is not in copy mode by
      running `copy-mode -q` on the runner.
      This sequence is then sent to make sure that the runner is ready to receive input.

      The default sends `C-u` to clear the line.
    '';
  };

  PromptString = defaultNullOpts.mkStr "Command? " ''
    The string presented in the vim command line when Vimux is invoked.

    Be sure to put a space at the end of the string to allow for distinction between the prompt
    and your input.
  '';

  RunnerType = defaultNullOpts.mkEnumFirstDefault [ "pane" "window" ] ''
    The type of view object Vimux should use for the runner.

    For reference, a tmux session is a group of windows, and a window is a layout of panes.
  '';

  RunnerName = defaultNullOpts.mkStr' {
    pluginDefault = "";
    example = "vimuxout";
    description = ''
      Setting the name for the runner.

      Works for panes and windows.
      This makes the VimuxRunner reusable between sessions.
      Caveat is, all your instances (in the same session/window) use the same window.

      Caution: It is probably best not to mix this with `CloseOnExit`.
    '';
  };

  TmuxCommand = defaultNullOpts.mkStr' {
    pluginDefault = "tmux";
    example = "tmate";
    description = ''
      The command that Vimux runs when it calls out to tmux.

      It may be useful to redefine this if you're using something like tmate.
    '';
  };

  OpenExtraArgs = defaultNullOpts.mkStr' {
    pluginDefault = "";
    example = "-c #{pane_current_path}";
    description = ''
      Allows additional arguments to be passed to the tmux command that opens the runner.

      Make sure that the arguments specified are valid depending on whether you're using panes or
      windows, and your version of tmux.
    '';
  };

  ExpandCommand = defaultNullOpts.mkFlagInt 0 ''
    Should the command given at the prompt via `PromptCommand` be expanded using `expand()`.

    Set to `1` to expand the string.

    Unfortunately `expand()` only expands `%` (etc.) if the string starts with that character.
    So the command is split at spaces and then rejoined after expansion.
    With this simple approach things like `"%:h/test.xml"` are not possible.
  '';

  CloseOnExit = defaultNullOpts.mkFlagInt 0 ''
    Set this option to `1` to tell vimux to close the runner when you quit vim.

    Caution: It is probably best not to mix this with `RunnerName`.
  '';

  CommandShell = defaultNullOpts.mkFlagInt 1 ''
    - Set this option to `1` to enable shell completion in `PromptCommand`.
    - Set this option to `0` to enable vim command editing in `PromptCommand`.

    Enabling shell completion blocks the ability to use up-arrow to cycle through previously-run
    commands in `PromptCommand`.
  '';

  RunnerQuery = defaultNullOpts.mkAttrsOf' {
    type = types.str;
    pluginDefault = { };
    example = {
      pane = "{down-of}";
      window = "vimux";
    };
    description = ''
      Set this option to define a query to use for looking up an existing runner pane or window
      when initiating Vimux.

      Uses the tmux syntax for the target-pane and target-window command arguments.
      (See the man page for tmux).

      It must be an attrs containing up to two keys, `pane` and `window`, defining the query to
      use for the respective runner types.

      If no key exists for the current runner type, the search for an existing runner falls back
      to the `UseNearest` option (and the related `RunnerName`).

      If that option is false or either command fails, a new runner is created instead, positioned
      according to `Orientation`.
    '';
  };

  Debug = defaultNullOpts.mkBool false ''
    If you're having trouble with vimux, set this option to get vimux to pass each tmux command to
    `|echomsg|` before running it.
  '';
}
