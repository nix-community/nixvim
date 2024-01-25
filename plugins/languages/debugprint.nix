{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.debugprint;
in {
  options.plugins.debugprint =
    helpers.neovim-plugin.extraOptionsOptions
    // {
      enable = mkEnableOption "debugprint.nvim";

      package = helpers.mkPackageOption "debugprint.nvim" pkgs.vimPlugins.debugprint-nvim;

      createCommands = helpers.defaultNullOpts.mkBool true ''
        Creates default commands.
      '';

      createKeymaps = helpers.defaultNullOpts.mkBool true ''
        Creates default keymappings.
      '';

      moveToDebugline = helpers.defaultNullOpts.mkBool false ''
        When adding a debug line, moves the cursor to that line.
      '';

      displayCounter = helpers.defaultNullOpts.mkBool true ''
        Whether to display/include the monotonically increasing counter in each debug message.
      '';

      displaySnippet = helpers.defaultNullOpts.mkBool true ''
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

                midVar = mkOption {
                  type = str;
                  description = "Middle part of snippet to insert (variable debug line mode).";
                };

                rightVar = mkOption {
                  type = str;
                  description = "Right part of snippet to insert (variable debug line mode).";
                };
              };
            })
        )
        "{}"
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
                midVar = "{";
                rightVar = "}')";
              };
            };
          ```
        '';

      ignoreTreesitter = helpers.defaultNullOpts.mkBool false ''
        Never use treesitter to find a variable under the cursor, always prompt for it - overrides
        the same setting on `debugprint()` if set to true.
      '';

      printTag = helpers.defaultNullOpts.mkStr "DEBUGPRINT" ''
        The string inserted into each print statement, which can be used to uniquely identify
        statements inserted by `debugprint`.
      '';
    };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];

    extraConfigLua = let
      setupOptions = with cfg;
        {
          create_commands = createCommands;
          create_keymaps = createKeymaps;
          move_to_debugline = moveToDebugline;
          display_counter = displayCounter;
          display_snippet = displaySnippet;
          filetypes =
            helpers.ifNonNull' filetypes
            (
              mapAttrs
              (
                _: ft: {
                  inherit (ft) left right;
                  mid_var = ft.midVar;
                  right_var = ft.rightVar;
                }
              )
              filetypes
            );
          ignore_treesitter = ignoreTreesitter;
          print_tag = printTag;
        }
        // cfg.extraOptions;
    in ''
      require('debugprint').setup(${helpers.toLuaObject setupOptions})
    '';
  };
}
