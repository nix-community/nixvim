lib: {
  imports =
    let
      basePluginPath = [
        "plugins"
        "gitlinker"
      ];
    in
    [
      (
        let
          oldPath = basePluginPath ++ [ "actionCallback" ];
        in
        lib.mkChangedOptionModule oldPath
          (
            basePluginPath
            ++ [
              "settings"
              "opts"
              "action_callback"
            ]
          )
          (
            config:
            let
              oldValue = lib.getAttrFromPath oldPath config;
            in
            if lib.isString oldValue then
              let
                newString = "require('gitlinker.actions').${oldValue}";
              in
              lib.warn ''
                WARNING: the `plugins.gitlinker.settings.opts.action_callback` does not automatically process the provided input.
                You will need to explicitly write `action_callback.__raw = "${newString}"`.
              '' lib.nixvim.mkRaw newString
            else
              oldValue
          )
      )
      (
        let
          oldPath = basePluginPath ++ [ "callbacks" ];
        in
        lib.mkChangedOptionModule oldPath
          (
            basePluginPath
            ++ [
              "settings"
              "callbacks"
            ]
          )
          (
            config:
            let
              oldValue = lib.getAttrFromPath oldPath config;
            in
            lib.mapAttrs (
              source: callback:
              if lib.isString callback then
                let
                  newString = "require('gitlinker.hosts').${callback}";
                in
                lib.warn ''
                  WARNING: the `plugins.gitlinker.settings.opts.action_callback` does not automatically process the provided input.
                  You will need to explicitly write `${callback}.__raw = "${newString}"`.
                '' lib.nixvim.mkRaw newString
              else
                callback
            ) oldValue
          )
      )
    ];
  deprecateExtraOptions = true;

  optionsRenamedToSettings = [
    {
      old = "remote";
      new = [
        "opts"
        "remote"
      ];
    }
    {
      old = "addCurrentLineOnNormalMode";
      new = [
        "opts"
        "add_current_line_on_normal_mode"
      ];
    }
    {
      old = "printUrl";
      new = [
        "opts"
        "print_url"
      ];
    }
    {
      old = "mappings";
      new = [
        "opts"
        "mappings"
      ];
    }
  ];
}
