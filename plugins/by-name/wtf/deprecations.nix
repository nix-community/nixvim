lib: {
  imports =
    let
      basePluginPath = [
        "plugins"
        "wtf"
      ];
    in
    [
      (lib.mkRemovedOptionModule
        (
          basePluginPath
          ++ [
            "keymaps"
          ]
        )
        ''
          Use nixvim's top-level `keymaps` option to manually declare your 'wtf-nvim' keymaps.
        ''
      )
      (lib.mkRemovedOptionModule (basePluginPath ++ [ "context" ]) ''
        context is no longer supported, please remove it from your config.
      '')
    ];

  deprecateExtraOptions = true;

  optionsRenamedToSettings = [
    {
      old = "openaiModelId";
      new = [
        "providers"
        "openai"
        "model_id"
      ];
    }
    {
      old = "openaiApiKey";
      new = [
        "providers"
        "openai"
        "api_key"
      ];
    }
  ]
  ++ map (lib.splitString ".") [
    "popupType"
    "language"
    "additionalInstructions"
    "searchEngine"
    "hooks.requestStarted"
    "hooks.requestFinished"
    "winhighlight"
  ];
}
