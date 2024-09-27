{
  lib,
  helpers,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "debugprint";
  originalName = "debugprint.nvim";
  package = "debugprint-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-04-07: remove 2024-06-07
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "moveToDebugline"
    "displayCounter"
    "displaySnippet"
    "ignoreTreesitter"
    "printTag"
  ];
  imports =
    let
      basePluginPath = [
        "plugins"
        "debugprint"
      ];
    in
    [
      (mkRemovedOptionModule (basePluginPath ++ [ "createCommands" ]) ''
        This option has been deprectaded upstream.
        Learn more [here](https://github.com/andrewferrier/debugprint.nvim/blob/796d8d4528bc5882d287b26e69cc8d810a9147c8/doc/debugprint.nvim.txt#L203-L213).
      '')
      (mkRemovedOptionModule (basePluginPath ++ [ "createKeymaps" ]) ''
        This option has been deprectaded upstream.
        Learn more [here](https://github.com/andrewferrier/debugprint.nvim/blob/796d8d4528bc5882d287b26e69cc8d810a9147c8/doc/debugprint.nvim.txt#L203-L213).
      '')
      (mkRemovedOptionModule (basePluginPath ++ [ "filetypes" ]) ''
        Please use `plugins.debugprint.settings.filetypes` instead.
        The sub-module options for each filetype are `left`, `right`, `mid_var` and `right_var`.
      '')
    ];

  settingsOptions = {
    keymaps =
      helpers.defaultNullOpts.mkAttrsOf (with lib.types; attrsOf (either str rawLua))
        {
          normal = {
            plain_below = "g?p";
            plain_above = "g?P";
            variable_below = "g?v";
            variable_above = "g?V";
            variable_below_alwaysprompt.__raw = "nil";
            variable_above_alwaysprompt.__raw = "nil";
            textobj_below = "g?o";
            textobj_above = "g?O";
            toggle_comment_debug_prints.__raw = "nil";
            delete_debug_prints.__raw = "nil";
          };
          visual = {
            variable_below = "g?v";
            variable_above = "g?V";
          };
        }
        ''
          By default, the plugin will create some keymappings for use 'out of the box'.
          There are also some function invocations which are not mapped to any keymappings by
          default, but could be.
          This can be overridden using this option.

          You only need to include the keys which you wish to override, others will default as shown
          in the documentation.
          Setting any key to `nil` (warning: use `__raw`) will skip it.

          The default keymappings are chosen specifically because ordinarily in NeoVim they are used
          to convert sections to ROT-13, which most folks don’t use.
        '';

    commands =
      helpers.defaultNullOpts.mkAttrsOf types.str
        {
          toggle_comment_debug_prints = "ToggleCommentDebugPrints";
          delete_debug_prints = "DeleteDebugPrints";
        }
        ''
          By default, the plugin will create some commands for use 'out of the box'.
          There are also some function invocations which are not mapped to any commands by default,
          but could be.
          This can be overridden using this option.

          You only need to include the commands which you wish to override, others will default as
          shown in the documentation.
          Setting any command to `nil` (warning: use `__raw`) will skip it.
        '';

    move_to_debugline = helpers.defaultNullOpts.mkBool false ''
      When adding a debug line, moves the cursor to that line.
    '';

    display_counter = helpers.defaultNullOpts.mkBool true ''
      Whether to display/include the monotonically increasing counter in each debug message.
    '';

    display_snippet = helpers.defaultNullOpts.mkBool true ''
      Whether to include a snippet of the line above/below in plain debug lines.
    '';

    filetypes =
      helpers.defaultNullOpts.mkNullable
        (
          with types;
          attrsOf (submodule {
            options = {
              left = mkOption {
                type = str;
                description = "Left part of snippet to insert.";
              };

              right = mkOption {
                type = str;
                description = "Right part of snippet to insert (plain debug line mode).";
              };

              mid_var = mkOption {
                type = str;
                description = "Middle part of snippet to insert (variable debug line mode).";
              };

              right_var = mkOption {
                type = str;
                description = "Right part of snippet to insert (variable debug line mode).";
              };
            };
          })
        )
        { }
        ''
          Custom filetypes.
          Your new file format will be merged in with those that already exist.
          If you pass in one that already exists, your configuration will override the built-in
          configuration.

          Example:
          ```nix
            filetypes = {
              python = {
                left = "print(f'";
                right = "')";
                mid_var = "{";
                right_var = "}')";
              };
            };
          ```
        '';

    print_tag = helpers.defaultNullOpts.mkStr "DEBUGPRINT" ''
      The string inserted into each print statement, which can be used to uniquely identify
      statements inserted by `debugprint`.
    '';
  };

  settingsExample = {
    keymaps = {
      normal = {
        variable_below = "g?v";
        variable_above = "g?V";
        variable_below_alwaysprompt.__raw = "nil";
        variable_above_alwaysprompt.__raw = "nil";
      };
      visual = {
        variable_below = "g?v";
        variable_above = "g?V";
      };
    };
    commands = {
      toggle_comment_debug_prints = "ToggleCommentDebugPrints";
      delete_debug_prints = "DeleteDebugPrints";
    };
    move_to_debugline = false;
    display_counter = true;
    display_snippet = true;
    filetypes = {
      python = {
        left = "print(f'";
        right = "')";
        mid_var = "{";
        right_var = "}')";
      };
    };
    print_tag = "DEBUGPRINT";
  };
}
