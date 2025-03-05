{
  root,
  lib,
  libToDoc,
  revision,
  libsets,
  prefix ? "lib",
  url ? "https://github.com/nix-community/nixvim/blob",
}:
let
  tryIsAttrs = v: (builtins.tryEval (builtins.isAttrs v)).value;

  libDefPos =
    prefix: set:
    builtins.concatMap (
      name:
      [
        {
          name = builtins.concatStringsSep "." (prefix ++ [ name ]);
          location = builtins.unsafeGetAttrPos name set;
        }
      ]
      ++ lib.optionals (builtins.length prefix == 0 && tryIsAttrs set.${name}) (
        libDefPos (prefix ++ [ name ]) set.${name}
      )
    ) (builtins.attrNames set);

  libset =
    toplib:
    builtins.map (subsetname: {
      inherit subsetname;
      functions = libDefPos [ ] toplib.${subsetname};
    }) (builtins.map (x: x.name) libsets);

  flattenedLibSubset =
    { subsetname, functions }:
    builtins.map (fn: {
      name = lib.concatStringsSep "." [
        prefix
        subsetname
        fn.name
      ];
      value = fn.location;
    }) functions;

  locatedlibsets = libs: builtins.map flattenedLibSubset (libset libs);
  removeFilenamePrefix =
    prefix: filename:
    let
      prefixLen = (builtins.stringLength prefix) + 1; # +1 to remove the leading /
      filenameLen = builtins.stringLength filename;
      substr = builtins.substring prefixLen filenameLen filename;
    in
    substr;

  removeNixvim = removeFilenamePrefix (builtins.toString root);

  liblocations = builtins.filter (elem: elem.value != null) (
    lib.lists.flatten (locatedlibsets libToDoc)
  );

  fnLocationRelative =
    { name, value }:
    {
      inherit name;
      value = value // {
        file = removeNixvim value.file;
      };
    };

  relativeLocs = builtins.map fnLocationRelative liblocations;
  sanitizeId = builtins.replaceStrings [ "'" ] [ "-prime" ];

  urlPrefix = "${url}/${revision}";
  jsonLocs = builtins.listToAttrs (
    builtins.map (
      { name, value }:
      {
        name = sanitizeId name;
        value =
          let
            text = "${value.file}:${builtins.toString value.line}";
            target = "${urlPrefix}/${value.file}#L${builtins.toString value.line}";
          in
          "[${text}](${target}) in `<nixvim>`";
      }
    ) relativeLocs
  );

in
jsonLocs
