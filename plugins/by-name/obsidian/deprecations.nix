{ lib, ... }:
let
  inherit (lib) mkRemovedOptionModule;
in
{
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
    {
      old = "finder";
      new = [
        "settings"
        "picker"
        "name"
      ];
    }
    # https://github.com/epwalsh/obsidian.nvim/blob/656d9c2c64528839db8b2d9a091843b3c90155a2/CHANGELOG.md?plain=1#L184
    {
      old = [
        "completion"
        "newNotesLocation"
      ];
      new = "new_notes_location";
    }
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
}
