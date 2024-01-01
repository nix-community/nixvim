{
  lib,
  helpers,
  config,
  pkgs,
  ...
}: let
  cfg = config.plugins.vim-slime;
in
  with lib; {
    options.plugins.vim-slime = {
      enable = mkEnableOption "vim-slime";

      package = helpers.mkPackageOption "vim-slime" pkgs.vimPlugins.vim-slime;

      target =
        helpers.defaultNullOpts.mkEnum
        [
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
        ]
        "screen"
        "Which backend vim-slime should use.";

      vimterminalCmd = helpers.mkNullOrOption types.str "The vim terminal command to execute.";

      noMappings = helpers.defaultNullOpts.mkBool false "Whether to disable the default mappings.";

      pasteFile = helpers.defaultNullOpts.mkStr "$HOME/.slime_paste" ''
        Required to transfer data from vim to GNU screen or tmux.
        Setting this explicitly can work around some occasional portability issues.
        whimrepl does not require or support this setting.
      '';

      preserveCurpos = helpers.defaultNullOpts.mkBool true ''
        Whether to preserve cursor position when sending a line or paragraph.
      '';

      defaultConfig =
        helpers.defaultNullOpts.mkNullable
        (with types; attrsOf (either str helpers.nixvimTypes.rawLua))
        "null"
        ''
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

      dontAskDefault = helpers.defaultNullOpts.mkBool false ''
        Whether to bypass the prompt and use the specified default configuration options.
      '';

      bracketedPaste = helpers.defaultNullOpts.mkBool false ''
        Sometimes REPL are too smart for their own good, e.g. autocompleting a bracket that should
        not be autocompleted when pasting code from a file.
        In this case it can be useful to rely on bracketed-paste
        (https://cirw.in/blog/bracketed-paste).
        Luckily, tmux knows how to handle that. See tmux's manual.
      '';

      extraConfig = mkOption {
        type = types.attrs;
        default = {};
        description = ''
          The configuration options for vim-slime without the 'slime_' prefix.
          Example: To set 'slime_foobar' to 1, write
          extraConfig = {
            foobar = true;
          };
        '';
      };
    };

    config = mkIf cfg.enable {
      extraPlugins = [cfg.package];

      globals =
        mapAttrs'
        (name: nameValuePair ("slime_" + name))
        (
          {
            inherit (cfg) target;
            vimterminal_cmd = cfg.vimterminalCmd;
            no_mappings = cfg.noMappings;
            paste_file = cfg.pasteFile;
            preserve_curpos = cfg.preserveCurpos;
            default_config = cfg.defaultConfig;
            dont_ask_default = cfg.dontAskDefault;
            bracketed_paste = cfg.bracketedPaste;
          }
          // cfg.extraConfig
        );
    };
  }
