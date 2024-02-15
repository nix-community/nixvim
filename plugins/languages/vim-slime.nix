{
  lib,
  config,
  helpers,
  pkgs,
  ...
}:
with lib;
with helpers.vim-plugin;
  mkVimPlugin config {
    name = "vim-slime";
    defaultPackage = pkgs.vimPlugins.vim-slime;
    globalPrefix = "slime_";
    addExtraConfigRenameWarning = true;

    options = {
      target = mkDefaultOpt {
        type = types.enum [
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
        ];
        description = ''
          Which backend vim-slime should use.

          Default: "screen"
        '';
        example = "dtach";
      };

      vimterminalCmd = mkDefaultOpt {
        global = "vimterminal_cmd";
        type = types.str;
        description = "The vim terminal command to execute.";
      };

      noMappings = mkDefaultOpt {
        global = "no_mappings";
        type = types.bool;
        description = ''
          Whether to disable the default mappings.

          Default: `false`
        '';
      };

      pasteFile = mkDefaultOpt {
        global = "paste_file";
        type = types.str;
        description = ''
          Required to transfer data from vim to GNU screen or tmux.
          Setting this explicitly can work around some occasional portability issues.
          whimrepl does not require or support this setting.

          Default: "$HOME/.slime_paste"
        '';
      };

      preserveCurpos = mkDefaultOpt {
        global = "preserve_curpos";
        type = types.bool;
        description = ''
          Whether to preserve cursor position when sending a line or paragraph.

          Default: `true`
        '';
      };

      defaultConfig = mkDefaultOpt {
        global = "default_config";
        type = with helpers.nixvimTypes; attrsOf (either str rawLua);
        description = ''
          Pre-filled prompt answer.

          Default: `null`

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
      };

      dontAskDefault = mkDefaultOpt {
        global = "dont_ask_default";
        type = types.bool;
        description = ''
          Whether to bypass the prompt and use the specified default configuration options.

          Default: `false`
        '';
      };

      bracketedPaste = mkDefaultOpt {
        global = "bracketed_paste";
        type = with types; nullOr bool;
        description = ''
          Sometimes REPL are too smart for their own good, e.g. autocompleting a bracket that should
          not be autocompleted when pasting code from a file.
          In this case it can be useful to rely on bracketed-paste
          (https://cirw.in/blog/bracketed-paste).
          Luckily, tmux knows how to handle that. See tmux's manual.

          Default: `false`
        '';
      };
    };
  }
