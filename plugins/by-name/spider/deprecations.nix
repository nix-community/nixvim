lib: {
  deprecateExtraOptions = true;
  imports =
    let
      basePluginPath = [
        "plugins"
        "spider"
      ];
    in
    [
      (lib.mkRenamedOptionModule (basePluginPath ++ [ "skipInsignificantPunctuation" ]) (
        basePluginPath
        ++ [
          "settings"
          "skipInsignificantPunctuation"
        ]
      ))
    ];
}
