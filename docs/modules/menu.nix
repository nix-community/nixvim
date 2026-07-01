{
  lib,
  config,
  options,
  ...
}:
let
  categories = lib.pipe options [
    builtins.attrNames
    (removeAttrs config)
    builtins.attrValues
    (map (x: x._category))
    (lib.sortOn (x: x.order))
  ];
in
{
  options._menu = {
    text = lib.mkOption {
      type = lib.types.str;
      description = "The rendered menu.";
      readOnly = true;
    };
    pages = lib.mkOption {
      type = lib.types.listOf lib.types.raw;
      description = "All pages in the menu.";
      readOnly = true;
    };
  };

  config._menu = {
    text = lib.pipe categories [
      (builtins.groupBy (x: x.type))
      (
        {
          prefix ? [ ],
          normal ? [ ],
          suffix ? [ ],
        }:
        prefix ++ normal ++ suffix
      )
      (map (x: x.text))
      (builtins.concatStringsSep "\n\n")
    ];
    pages = lib.concatMap (x: x.pages) categories;
  };
}
