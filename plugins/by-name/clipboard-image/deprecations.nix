{ lib }:
{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "plugins"
        "clipboard-image"
        "filetypes"
      ]
      ''
        Please use `plugins.clipboard-image.settings` for each filetype configuration instead.
        The attribute key is the name of the filetype and contains the same options as the default key.

        Note that nested options will now be snake_case, as well, to match upstream plugin configuration.
      ''
    )
  ];

  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    [
      "default"
      "imgDir"
    ]
    [
      "default"
      "imgDirTxt"
    ]
    [
      "default"
      "imgName"
    ]
    [
      "default"
      "imgHandler"
    ]
    [
      "default"
      "affix"
    ]
  ];
}
