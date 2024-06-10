{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
(import ./_helpers.nix {
  inherit
    lib
    helpers
    config
    pkgs
    ;
}).mkExtension
  {
    name = "frecency";
    defaultPackage = pkgs.vimPlugins.telescope-frecency-nvim;

    # TODO: introduced 2024-03-24, remove on 2024-05-24
    optionsRenamedToSettings = [
      "dbRoot"
      "defaultWorkspace"
      "ignorePatterns"
      "showScores"
      "workspaces"
    ];
    imports =
      let
        basePluginPath = [
          "plugins"
          "telescope"
          "extensions"
          "frecency"
        ];
      in
      [
        (mkRemovedOptionModule (
          basePluginPath ++ [ "showUnindexed" ]
        ) "This option has been removed upstream.")
        (mkRemovedOptionModule (
          basePluginPath ++ [ "deviconsDisabled" ]
        ) "This option has been removed upstream.")
      ];

    settingsOptions = {
      auto_validate = helpers.defaultNullOpts.mkBool true ''
        If true, it removes stale entries count over than `db_validate_threshold`.
      '';

      db_root = helpers.defaultNullOpts.mkStr { __raw = "vim.fn.stdpath 'data'"; } ''
        Path to parent directory of custom database location.
        Defaults to `$XDG_DATA_HOME/nvim` if unset.
      '';

      db_safe_mode = helpers.defaultNullOpts.mkBool true ''
        If true, it shows confirmation dialog by `vim.ui.select()` before validating DB.
      '';

      db_validate_threshold = helpers.defaultNullOpts.mkUnsignedInt 10 ''
        It will removes over than this count in validating DB.
      '';

      default_workspace = helpers.mkNullOrStr ''
        Default workspace tag to filter by e.g. `'CWD'` to filter by default to the current
        directory.
        Can be overridden at query time by specifying another filter like `':*:'`.
      '';

      disable_devicons = helpers.defaultNullOpts.mkBool false ''
        Disable devicons (if available).
      '';

      hide_current_buffer = helpers.defaultNullOpts.mkBool false ''
        If true, it does not show the current buffer in candidates.
      '';

      filter_delimiter = helpers.defaultNullOpts.mkStr ":" ''
        Delimiters to indicate the filter like `:CWD:`.
      '';

      ignore_patterns =
        helpers.defaultNullOpts.mkListOf types.str
          [
            "*.git/*"
            "*/tmp/*"
            "term://*"
          ]
          ''
            Patterns in this table control which files are indexed (and subsequently which you'll see
            in the finder results).
          '';

      max_timestamps = helpers.defaultNullOpts.mkPositiveInt 10 ''
        Set the max count of timestamps DB keeps when you open files.
        It ignores the value and use `10` if you set less than or equal to `0`.

        CAUTION: When you reduce the value of this option, it removes old timestamps when you open
        the file.
        It is reasonable to set this value more than or equal to the default value: `10`.
      '';

      show_filter_column =
        helpers.defaultNullOpts.mkNullableWithRaw (with types; either bool (listOf str)) true
          ''
            Show the path of the active filter before file paths.
            In default, it uses the tail of paths for `'LSP'` and `'CWD'` tags.
            You can configure this by setting a table for this option.
          '';

      show_scores = helpers.defaultNullOpts.mkBool false ''
        To see the scores generated by the algorithm in the results, set this to true.
      '';

      show_unindexed = helpers.defaultNullOpts.mkBool true ''
        Determines if non-indexed files are included in workspace filter results.
      '';

      workspace_scan_cmd =
        helpers.mkNullOrOption (with helpers.nixvimTypes; either rawLua (listOf str))
          ''
            This option can be set values as `"LUA"|string[]|null`.
            With the default value: `null`, it uses these way below to make entries for workspace
            files.
            It tries in order until it works successfully.

            1. `rg -.g '!.git' --files`
            2. `fdfind -Htf`
            3. `fd -Htf`
            4. Native Lua code (old way)

            If you like another commands, set them to this option, like
            ```nix
              workspace_scan_cmd = ["find" "." "-type" "f"];
            ```

            If you prefer Native Lua code, set `workspace_scan_cmd.__raw = "LUA"`.
          '';

      workspaces = helpers.defaultNullOpts.mkAttrsOf types.str { } ''
        This attrs contains mappings of `workspace_tag` -> `workspace_directory`.
        The key corresponds to the `:tag_name` used to select the filter in queries.
        The value corresponds to the top level directory by which results will be filtered.
      '';
    };

    settingsExample = {
      db_root = "/home/my_username/path/to/db_root";
      show_scores = false;
      show_unindexed = true;
      ignore_patterns = [
        "*.git/*"
        "*/tmp/*"
      ];
      disable_devicons = false;
      workspaces = {
        conf = "/home/my_username/.config";
        data = "/home/my_username/.local/share";
        project = "/home/my_username/projects";
        wiki = "/home/my_username/wiki";
      };
    };
  }
