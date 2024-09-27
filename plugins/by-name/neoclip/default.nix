{
  lib,
  config,
  helpers,
  options,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "neoclip";
  originalName = "nvim-neoclip.lua";
  package = "nvim-neoclip-lua";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    history = helpers.defaultNullOpts.mkUnsignedInt 1000 ''
      The max number of entries to store.
    '';

    enable_persistent_history = helpers.defaultNullOpts.mkBool false ''
      If set to `true` the history is stored on `VimLeavePre` using `sqlite.lua` and lazy loaded when
      querying.
    '';

    length_limit = helpers.defaultNullOpts.mkUnsignedInt 1048576 ''
      The max number of characters of an entry to be stored (default 1MiB).
      If the length of the yanked string is larger than the limit, it will not be stored.
    '';

    continuous_sync = helpers.defaultNullOpts.mkBool false ''
      If set to `true`, the runtime history is synced with the persistent storage everytime it's
      changed or queried.

      If you often use multiple sessions in parallel and wants the history synced you might want to
      enable this.

      Off by default; it can cause delays because the history file is written everytime you yank
      something.
      Although, in practice no real slowdowns were noticed.

      Alternatively see `db_pull` and `db_push` functions in the
      [README](https://github.com/AckslD/nvim-neoclip.lua#custom-actions).
    '';

    db_path =
      helpers.defaultNullOpts.mkStr { __raw = "vim.fn.stdpath('data') .. '/databases/neoclip.sqlite3'"; }
        ''
          The path to the sqlite database to store history if `enable_persistent_history=true`.
          Defaults to `$XDG_DATA_HOME/nvim/databases/neoclip.sqlite3`.
        '';

    filter = helpers.defaultNullOpts.mkLuaFn null ''
      A function to filter what entries to store (default all are stored).
      This function filter should return `true` (include the yanked entry) or `false` (don't include
      it) based on a table as the only argument, which has the following keys:

      - `event`: The event from `TextYankPost` (see ``:help TextYankPost` for which keys it contains).
      - `filetype`: The filetype of the buffer where the yank happened.
      - `buffer_name`: The name of the buffer where the yank happened.
    '';

    preview = helpers.defaultNullOpts.mkBool true ''
      Whether to show a preview (default) of the current entry or not.
      Useful for for example multiline yanks.
      When yanking the filetype is recorded in order to enable correct syntax highlighting in the
      preview.

      NOTE: in order to use the dynamic title showing the type of content and number of lines you
      need to configure `telescope` with the `dynamic_preview_title = true` option.
    '';

    prompt = helpers.defaultNullOpts.mkStr null ''
      The prompt string used by the picker (`telescope`/`fzf-lua`).
    '';

    default_register =
      helpers.defaultNullOpts.mkNullable (with lib.types; either str (listOf str)) "\""
        ''
          What register to use by default when not specified (e.g. `Telescope neoclip`).
          Can be a string such as `"\""` (single register) or a table of strings such as
          `["\"" "+" "*"]`.
        '';

    default_register_macros = helpers.defaultNullOpts.mkStr "q" ''
      What register to use for macros by default when not specified (e.g. `Telescope macroscope`).
    '';

    enable_macro_history = helpers.defaultNullOpts.mkBool true ''
      If true (default) any recorded macro will be saved, see
      [macros](https://github.com/AckslD/nvim-neoclip.lua#macros).
    '';

    content_spec_column = helpers.defaultNullOpts.mkBool false ''
      Can be set to `true` to use instead of the preview.
    '';

    disable_keycodes_parsing = helpers.defaultNullOpts.mkBool false ''
      If set to true, macroscope will display the internal byte representation, instead of a proper
      string that can be used in a map.

      So a macro like `"one<CR>two"` will be displayed as `"one\ntwo"`.
      It will only show the type and number of lines next to the first line of the entry.
    '';

    on_select = {
      move_to_front = helpers.defaultNullOpts.mkBool false ''
        If the entry should be set to last in the list when pressing the key to select a yank.
      '';

      close_telescope = helpers.defaultNullOpts.mkBool true ''
        If telescope should close whenever an item is selected.
      '';
    };

    on_paste = {
      set_reg = helpers.defaultNullOpts.mkBool false ''
        If the register should be populated when pressing the key to paste directly.
      '';

      move_to_front = helpers.defaultNullOpts.mkBool false ''
        If the entry should be set to last in the list when pressing the key to paste directly.
      '';

      close_telescope = helpers.defaultNullOpts.mkBool true ''
        If `telescope` should close whenever a yank is pasted.
      '';
    };

    on_replay = {
      set_reg = helpers.defaultNullOpts.mkBool false ''
        If the register should be populated when pressing the key to replay a recorded macro.
      '';

      move_to_front = helpers.defaultNullOpts.mkBool false ''
        If the entry should be set to last in the list when pressing the key to replay a recorded
        macro.
      '';

      close_telescope = helpers.defaultNullOpts.mkBool true ''
        If telescope should close whenever a macro is replayed.
      '';
    };

    on_custom_action = {
      close_telescope = helpers.defaultNullOpts.mkBool true ''
        If telescope should close whenever a custom action is executed.
      '';
    };

    keys = {
      telescope =
        # Using `anything` here because of the annoying `custom` key (and also, a mapping can target several keys):
        # https://github.com/AckslD/nvim-neoclip.lua?tab=readme-ov-file#custom-actions
        helpers.defaultNullOpts.mkAttrsOf (with types; attrsOf anything)
          {
            i = {
              select = "<cr>";
              paste = "<c-p>";
              paste_behind = "<c-k>";
              replay = "<c-q>";
              delete = "<c-d>";
              edit = "<c-e>";
              custom = { };
            };
            n = {
              select = "<cr>";
              paste = "p";
              paste_behind = "P";
              replay = "q";
              delete = "d";
              edit = "e";
              custom = { };
            };
          }
          ''
            Keys to use for the `telescope` picker.
            Normal key-syntax is supported and both insert `i` and normal mode `n`.
            You can also use the `custom` entry to specify custom actions to take on certain
            key-presses, see
            [here](https://github.com/AckslD/nvim-neoclip.lua?tab=readme-ov-file#custom-actions) for
            more details.

            NOTE: these are only set in the telescope buffer and you need to setup your own keybindings to for example open telescope.
          '';

      fzf =
        helpers.defaultNullOpts.mkAttrsOf types.anything
          {
            select = "default";
            paste = "ctrl-p";
            paste_behind = "ctrl-k";
            custom = { };
          }
          ''
            Keys to use for the `fzf` picker.
            Only insert mode is supported and fzf-style key-syntax needs to be used.
            You can also use the `custom` entry to specify custom actions to take on certain
            key-presses, see
            [here](https://github.com/AckslD/nvim-neoclip.lua?tab=readme-ov-file#custom-actions) for
            more details.
          '';
    };
  };

  settingsExample = {
    filter = null;
    preview = true;
    default_register = "\"";
    content_spec_column = false;
    on_paste = {
      set_reg = false;
    };
    keys = {
      telescope = {
        i = {
          select = "<cr>";
          paste = "<c-l>";
          paste_behind = "<c-h>";
          custom = { };
        };
        n = {
          select = "<cr>";
          paste = "p";
          paste_behind = "P";
          custom = { };
        };
      };
      fzf = {
        select = "default";
        paste = "ctrl-l";
        paste_behind = "ctrl-h";
        custom = { };
      };
    };
  };

  extraConfig = cfg: {
    # TODO: added 2024-09-14 remove after 24.11
    plugins.sqlite-lua.enable = mkOverride 1490 true;
    warnings =
      optional
        (
          isBool cfg.settings.enable_persistent_history
          && cfg.settings.enable_persistent_history
          && options.plugins.sqlite-lua.enable.highestPrio == 1490
        )
        ''
          Nixvim (plugins.neoclip) `sqlite-lua` automatic installation is deprecated.
          Please use `plugins.sqlite-lua.enable`.
        '';

    assertions = [
      {
        assertion =
          isBool cfg.settings.enable_persistent_history && cfg.settings.enable_persistent_history
          -> config.plugins.sqlite-lua.enable;
        message = ''
          Nixvim (plugins.neoclip): The persistent history sqlite storage backend needs `sqlite-lua` to function as intended.
          You can enable it by setting `plugins.sqlite-lua.enable` to `true`.
        '';
      }
    ];
  };
}
