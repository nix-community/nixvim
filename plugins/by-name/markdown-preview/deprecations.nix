{
  # TODO introduced 2024-03-02: remove 2024-05-02
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [
    "autoStart"
    "autoClose"
    "refreshSlow"
    "commandForGlobal"
    "openToTheWorld"
    "openIp"
    "browser"
    "echoPreviewUrl"
    "previewOptions"
    "markdownCss"
    "highlightCss"
    "port"
    "pageTitle"
    "theme"
    {
      old = "fileTypes";
      new = "filetypes";
    }
    {
      old = "browserFunc";
      new = "browserfunc";
    }
  ];

}
