{
  lib,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "debugprint";
  package = "debugprint-nvim";
  description = "A Neovim plugin for inserting debug print statements.";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    keymaps =
      lib.nixvim.defaultNullOpts.mkAttrsOf (with lib.types; attrsOf (either str rawLua))
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
      lib.nixvim.defaultNullOpts.mkAttrsOf types.str
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

    move_to_debugline = lib.nixvim.defaultNullOpts.mkBool false ''
      When adding a debug line, moves the cursor to that line.
    '';

    display_counter = lib.nixvim.defaultNullOpts.mkBool true ''
      Whether to display/include the monotonically increasing counter in each debug message.
    '';

    display_snippet = lib.nixvim.defaultNullOpts.mkBool true ''
      Whether to include a snippet of the line above/below in plain debug lines.
    '';

    filetypes =
      lib.nixvim.defaultNullOpts.mkNullable
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

    print_tag = lib.nixvim.defaultNullOpts.mkStr "DEBUGPRINT" ''
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
