lib: {
  deprecateExtraOptions = true;

  optionsRenamedToSettings = map (lib.splitString ".") [
    "autoEnable"
    "magicWindow"
    "autoResizeHeight"

    "preview.autoPreview"
    "preview.borderChars"
    "preview.showTitle"
    "preview.delaySyntax"
    "preview.winHeight"
    "preview.winVheight"
    "preview.wrap"
    "preview.bufLabel"
    "preview.shouldPreviewCb"

    "funcMap"

    "filter.fzf.actionFor"
    "filter.fzf.extraOpts"
  ];
}
