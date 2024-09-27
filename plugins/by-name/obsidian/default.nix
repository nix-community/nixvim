{
  lib,
  helpers,
  config,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "obsidian";
  originalName = "obsidian.nvim";
  package = "obsidian-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  ## DEPRECATIONS
  # Introduced 2024-03-12
  # TODO: remove 2024-05-12
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "dir"
    "logLevel"
    "notesSubdir"
    [
      "templates"
      "subdir"
    ]
    [
      "templates"
      "dateFormat"
    ]
    [
      "templates"
      "timeFormat"
    ]
    [
      "templates"
      "substitutions"
    ]
    "noteIdFunc"
    "followUrlFunc"
    "noteFrontmatterFunc"
    "disableFrontmatter"
    [
      "completion"
      "nvimCmp"
    ]
    [
      "completion"
      "minChars"
    ]
    "mappings"
    [
      "dailyNotes"
      "folder"
    ]
    [
      "dailyNotes"
      "dateFormat"
    ]
    [
      "dailyNotes"
      "aliasFormat"
    ]
    [
      "dailyNotes"
      "template"
    ]
    "useAdvancedUri"
    "openAppForeground"
    "sortBy"
    "sortReversed"
    "openNotesIn"
    [
      "ui"
      "enable"
    ]
    [
      "ui"
      "updateDebounce"
    ]
    [
      "ui"
      "externalLinkIcon"
      "char"
    ]
    [
      "ui"
      "externalLinkIcon"
      "hlGroup"
    ]
    [
      "ui"
      "referenceText"
      "hlGroup"
    ]
    [
      "ui"
      "highlightText"
      "hlGroup"
    ]
    [
      "ui"
      "tags"
      "hlGroup"
    ]
    [
      "ui"
      "hlGroups"
    ]
    [
      "attachments"
      "imgFolder"
    ]
    [
      "attachments"
      "imgTextFunc"
    ]
    "yamlParser"
  ];
  imports =
    let
      basePluginPath = [
        "plugins"
        "obsidian"
      ];
    in
    [
      (
        # We have to remove the option here because the user could set old-style camelCase options in each workspaces element.
        mkRemovedOptionModule (
          basePluginPath ++ [ "workspaces" ]
        ) "Please use `plugins.obsidian.settings.workspaces` instead."
      )
      (mkRenamedOptionModule (basePluginPath ++ [ "finder" ]) (
        basePluginPath
        ++ [
          "settings"
          "picker"
          "name"
        ]
      ))
      (
        # https://github.com/epwalsh/obsidian.nvim/blob/656d9c2c64528839db8b2d9a091843b3c90155a2/CHANGELOG.md?plain=1#L184
        mkRenamedOptionModule
          (
            basePluginPath
            ++ [
              "completion"
              "newNotesLocation"
            ]
          )
          (
            basePluginPath
            ++ [
              "settings"
              "new_notes_location"
            ]
          )
      )
      (
        # We have to remove the option here because the user could set old-style camelCase options in each checkbox element.
        mkRemovedOptionModule (
          basePluginPath
          ++ [
            "ui"
            "checkboxes"
          ]
        ) "Please use `plugins.obsidian.settings.ui.checkboxes` instead."
      )
    ]
    ++ (map
      (
        optionPath:
        mkRemovedOptionModule (basePluginPath ++ optionPath) "This option was deprecated by upstream."
      )
      [
        [ "detectCwd" ]
        [ "backlinks" ]
        [
          "completion"
          "prependNoteId"
        ]
        [
          "completion"
          "prependNotePath"
        ]
        [
          "completion"
          "usePathOnly"
        ]
      ]
    );

  settingsOptions =
    let
      opts = import ./options.nix { inherit lib helpers; };
    in
    {
      dir = helpers.mkNullOrOption types.str ''
        Alternatively to `workspaces` - and for backwards compatibility - you can set `dir` to a
        single path instead of `workspaces`.

        For example:
        ```nix
          dir = "~/vaults/work";
        ```
      '';

      workspaces =
        helpers.defaultNullOpts.mkNullable
          (
            with types;
            listOf (
              types.submodule {
                options = {
                  name = mkOption {
                    type = with lib.types; maybeRaw str;
                    description = "The name for this workspace";
                  };

                  path = mkOption {
                    type = with lib.types; maybeRaw str;
                    description = "The of the workspace.";
                  };

                  overrides = opts;
                };
              }
            )
          )
          [ ]
          ''
            A list of vault names and paths.
            Each path should be the path to the vault root.
            If you use the Obsidian app, the vault root is the parent directory of the `.obsidian`
            folder.
            You can also provide configuration overrides for each workspace through the `overrides`
            field.
          '';
    }
    // opts;

  settingsExample = {
    workspaces = [
      {
        name = "work";
        path = "~/obsidian/work";
      }
      {
        name = "startup";
        path = "~/obsidian/startup";
      }
    ];
    new_notes_location = "current_dir";
    completion = {
      nvim_cmp = true;
      min_chars = 2;
    };
  };

  extraConfig = cfg: {
    warnings =
      let
        nvimCmpEnabled = isBool cfg.settings.completion.nvim_cmp && cfg.settings.completion.nvim_cmp;
      in
      optional (nvimCmpEnabled && !config.plugins.cmp.enable) ''
        Nixvim (plugins.obsidian): You have enabled `completion.nvim_cmp` but `plugins.cmp.enable` is `false`.
        You should probably enable `nvim-cmp`.
      '';
  };
}
