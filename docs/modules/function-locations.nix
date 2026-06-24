# Generates an attrset of "function name" → "markdown location",
# for use with nixdoc's `--locs` option.
#
# {
#   "lib.nixvim.foo.bar" = "[lib/foo.nix:123](https://github.com/nix-community/nixvim/blob/«rev»/lib/foo.nix#L123) in `<nixvim>`";
# }
{
  rootPath,
  lib,
  functionSet,
  pathsToScan,
  revision,
  functionSetName ? "lib",
  url ? "https://github.com/nix-community/nixvim/blob",
}:
let
  rootPathString = toString rootPath;
  urlPrefix = "${url}/${revision}";

  sanitizeId = builtins.replaceStrings [ "'" ] [ "-prime" ];

  # Like `isAttrs`, but returns `false` if `v` throws
  tryIsAttrs = v: (builtins.tryEval (builtins.isAttrs v)).value;

  # Collect position entries from an attrset
  # `prefix` is used in the human-readable name,
  # and for determining whether to recurse into attrs
  collectPositionEntriesInSet =
    prefix: set:
    builtins.concatMap (
      name:
      [
        {
          name = lib.showAttrPath (
            builtins.concatMap lib.toList [
              functionSetName
              prefix
              name
            ]
          );
          location = builtins.unsafeGetAttrPos name set;
        }
      ]
      ++ lib.optionals (prefix == [ ] && tryIsAttrs set.${name}) (
        collectPositionEntriesInSet (prefix ++ [ name ]) set.${name}
      )
    ) (builtins.attrNames set);

  # Collect position entries from each `pathsToScan` in `set`
  collectPositionEntriesFromPaths =
    set:
    builtins.concatMap (loc: collectPositionEntriesInSet loc (lib.getAttrFromPath loc set)) pathsToScan;

  # Remove the tree root (usually the top-level store path)
  removeNixvimPrefix = lib.flip lib.pipe [
    (lib.strings.removePrefix rootPathString)
    (lib.strings.removePrefix "/")
  ];

  # Create a name-value-pair for use with `listToAttrs`
  entryToNameValuePair =
    { name, location }:
    {
      name = sanitizeId name;
      value =
        let
          file = removeNixvimPrefix location.file;
          line = toString location.line;
          text = "${file}:${line}";
          target = "${urlPrefix}/${file}#L${line}";
        in
        "[${text}](${target}) in `<nixvim>`";
    };
in
lib.pipe functionSet [
  # Get the entries
  collectPositionEntriesFromPaths
  # Only include entries that have a location
  (builtins.filter (entry: entry.location != null))
  # No need to include out-of-tree entries
  (builtins.filter (entry: lib.strings.hasPrefix rootPathString entry.location.file))
  # Convert entries to attrset
  (map entryToNameValuePair)
  builtins.listToAttrs
]
