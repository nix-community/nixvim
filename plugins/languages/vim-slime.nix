{
  lib,
  helpers,
  ...
}:
with lib;
with helpers.vim-plugin;
mkVimPlugin {
  name = "vim-slime";
  globalPrefix = "slime_";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-03-02: remove 2024-05-02
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [
    "target"
    "vimterminalCmd"
    "noMappings"
    "pasteFile"
    "preserveCurpos"
    "defaultConfig"
    "dontAskDefault"
    "bracketedPaste"
  ];

  settingsOptions = {
    target = helpers.defaultNullOpts.mkEnum [
      "dtach"
      "kitty"
      "neovim"
      "screen"
      "tmux"
      "vimterminal"
      "wezterm"
      "whimrepl"
      "x11"
      "zellij"
    ] "screen" "Which backend vim-slime should use.";

    vimterminal_cmd = helpers.mkNullOrStr ''
      The vim terminal command to execute.
    '';

    no_mappings = helpers.defaultNullOpts.mkBool false ''
      Whether to disable the default mappings.
    '';

    paste_file = helpers.defaultNullOpts.mkStr "$HOME/.slime_paste" ''
      Required to transfer data from vim to GNU screen or tmux.
      Setting this explicitly can work around some occasional portability issues.
      whimrepl does not require or support this setting.
    '';

    preserve_curpos = helpers.defaultNullOpts.mkBool true ''
      Whether to preserve cursor position when sending a line or paragraph.
    '';

    default_config = helpers.mkNullOrOption (with helpers.nixvimTypes; attrsOf (either str rawLua)) ''
      Pre-filled prompt answer.

      Examples:
        - `tmux`:
          ```nix
            {
              socket_name = "default";
              target_pane = "{last}";
            }
          ```
        - `zellij`:
          ```nix
            {
              session_id = "current";
              relative_pane = "right";
            }
          ```
    '';

    dont_ask_default = helpers.defaultNullOpts.mkBool false ''
      Whether to bypass the prompt and use the specified default configuration options.
    '';

    bracketed_paste = helpers.defaultNullOpts.mkBool false ''
      Sometimes REPL are too smart for their own good, e.g. autocompleting a bracket that should
      not be autocompleted when pasting code from a file.
      In this case it can be useful to rely on bracketed-paste
      (https://cirw.in/blog/bracketed-paste).
      Luckily, tmux knows how to handle that. See tmux's manual.
    '';
  };

  settingsExample = {
    target = "screen";
    vimterminal_cmd = null;
    no_mappings = false;
    paste_file = "$HOME/.slime_paste";
    preserve_curpos = true;
    default_config = {
      socket_name = "default";
      target_pane = "{last}";
    };
    dont_ask_default = false;
    bracketed_paste = false;
  };
}
