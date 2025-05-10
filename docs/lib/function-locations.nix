{
  root,
  lib,
  functionSet,
  functionSets,
  revision,
  functionSetName ? "lib",
  url ? "https://github.com/nix-community/nixvim/blob",
}:
let
  urlPrefix = "${url}/${revision}";

  sanitizeId = builtins.replaceStrings [ "'" ] [ "-prime" ];

  tryIsAttrs = v: (builtins.tryEval (builtins.isAttrs v)).value;

  getDefPositions =
    prefix: set:
    builtins.concatMap (
      name:
      [
        {
          name = builtins.concatStringsSep "." ([ functionSetName ] ++ prefix ++ [ name ]);
          location = builtins.unsafeGetAttrPos name set;
        }
      ]
      ++ lib.optionals (builtins.length prefix == 0 && tryIsAttrs set.${name}) (
        getDefPositions (prefix ++ [ name ]) set.${name}
      )
    ) (builtins.attrNames set);

  getFnSubset =
    set:
    builtins.concatMap (
      {
        name,
        path ? [ name ],
        ...
      }:
      getDefPositions path (lib.getAttrFromPath path set)
    ) functionSets;

  removeFilenamePrefix =
    prefix: filename:
    let
      prefixLen = (builtins.stringLength prefix) + 1; # +1 to remove the leading /
      filenameLen = builtins.stringLength filename;
    in
    builtins.substring prefixLen filenameLen filename;

  removeNixvimPrefix = removeFilenamePrefix (builtins.toString root);

  toEntry =
    { name, location }:
    {
      name = sanitizeId name;
      value =
        let
          file = removeNixvimPrefix location.file;
          line = builtins.toString location.line;
          text = "${file}:${line}";
          target = "${urlPrefix}/${file}#L${line}";
        in
        "[${text}](${target}) in `<nixvim>`";
    };
in
lib.pipe functionSet [
  getFnSubset
  (builtins.filter (elem: elem.location != null))
  # We only want to document functions defined in our tree
  (builtins.filter (elem: lib.strings.hasPrefix (builtins.toString root) elem.location.file))
  (builtins.map toEntry)
  builtins.listToAttrs
]
