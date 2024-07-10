{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  telescopeHelpers = import ./_helpers.nix {
    inherit
      lib
      helpers
      config
      pkgs
      ;
  };
in
telescopeHelpers.mkExtension {
  name = "undo";
  defaultPackage = pkgs.vimPlugins.telescope-undo-nvim;

  # TODO: introduced 2024-03-24, remove on 2024-05-24
  optionsRenamedToSettings = [
    "useDelta"
    "useCustomCommand"
    "sideBySide"
    "diffContextLines"
    "entryFormat"
    "timeFormat"
  ];
  imports = [
    (mkRemovedOptionModule
      [
        "plugins"
        "telescope"
        "extensions"
        "undo"
        "mappings"
      ]
      ''
        Use `plugins.telescope.extension.undo.settings.mappings` instead but beware, you need to specify the full name of the callback:
        Example:
        ```
          mappings = {
            i = {
              "<cr>" = "require('telescope-undo.actions').yank_additions";
              "<s-cr>" = "require('telescope-undo.actions').yank_deletions";
              "<c-cr>" = "require('telescope-undo.actions').restore";
            };
            n = {
              "y" = "require('telescope-undo.actions').yank_additions";
              "Y" = "require('telescope-undo.actions').yank_deletions";
              "u" = "require('telescope-undo.actions').restore";
            };
          }
        ```
      ''
    )
  ];

  settingsOptions = {
    use_delta = helpers.defaultNullOpts.mkBool true ''
      When set to true, [delta](https://github.com/dandavison/delta) is used for fancy diffs in
      the preview section.
      If set to false, `telescope-undo` will not use `delta` even when available and fall back to a
      plain diff with treesitter highlights.
    '';

    use_custom_command = helpers.mkNullOrOption (with types; listOf str) ''
      Should be in this format: `[ "bash" "-c" "echo '$DIFF' | delta" ]`
    '';

    side_by_side = helpers.defaultNullOpts.mkBool false ''
      If set to true tells `delta` to render diffs side-by-side. Thus, requires `delta` to be used.
      Be aware that `delta` always uses its own configuration, so it might be that you're getting
      the side-by-side view even if this is set to false.
    '';

    vim_diff_opts = {
      ctxlen = helpers.defaultNullOpts.mkStrLuaOr types.ints.unsigned "vim.o.scrolloff" ''
        Defaults to the scrolloff.
      '';
    };

    entry_format = helpers.defaultNullOpts.mkStr "state #$ID, $STAT, $TIME" ''
      The format to show on telescope for the different versions of the file.
    '';

    time_format = helpers.defaultNullOpts.mkStr "" ''
      Can be set to a [Lua date format string](https://www.lua.org/pil/22.1.html).
    '';

    mappings = telescopeHelpers.mkMappingsOption {
      insertDefaults = ''
        {
          "<cr>" = "require('telescope-undo.actions').yank_additions";
          "<s-cr>" = "require('telescope-undo.actions').yank_deletions";
          "<c-cr>" = "require('telescope-undo.actions').restore";
        }
      '';

      normalDefaults = ''
        {
          "y" = "require('telescope-undo.actions').yank_additions";
          "Y" = "require('telescope-undo.actions').yank_deletions";
          "u" = "require('telescope-undo.actions').restore";
        }
      '';
    };
  };

  settingsExample = {
    use_delta = true;
    use_custom_command = [
      "bash"
      "-c"
      "echo '$DIFF' | delta"
    ];
    side_by_side = true;
    vim_diff_opts.ctxlen = 8;
    entry_format = "state #$ID";
    time_format = "!%Y-%m-%dT%TZ";
    mappings = {
      i = {
        "<cr>" = "require('telescope-undo.actions').yank_additions";
        "<s-cr>" = "require('telescope-undo.actions').yank_deletions";
        "<c-cr>" = "require('telescope-undo.actions').restore";
      };
      n = {
        "y" = "require('telescope-undo.actions').yank_additions";
        "Y" = "require('telescope-undo.actions').yank_deletions";
        "u" = "require('telescope-undo.actions').restore";
      };
    };
  };
}
