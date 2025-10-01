lib:
let
  inherit (lib) mapAttrs' nameValuePair;
  inherit (lib.nixvim) ifNonNull';
  basePathAnd = lib.concat [
    "plugins"
    "rainbow-delimiters"
  ];
in
{
  deprecateExtraOptions = true;

  optionsRenamedToSettings = map (lib.splitString ".") [
    "highlight"
    "whitelist"
    "blacklist"
    "log.file"
    "log.level"
  ];

  imports = [
    (
      let
        oldOptPath = basePathAnd [ "query" ];
      in
      lib.mkChangedOptionModule oldOptPath
        (basePathAnd [
          "settings"
          "query"
        ])
        (
          config:
          let
            old = lib.getAttrFromPath oldOptPath config;
          in
          ifNonNull' old (mapAttrs' (n: nameValuePair (if n == "default" then "" else n)) old)
        )
    )
  ];
}
