{
  lib,
  config,
  options,
  ...
}:
let
  categoryType = lib.types.submoduleWith {
    modules = [ ./category.nix ];
  };

  categories = builtins.removeAttrs config (builtins.attrNames options);
in
{
  freeformType = lib.types.attrsOf categoryType;

  options._menu = {
    text = lib.mkOption {
      type = lib.types.str;
      description = "The rendered menu.";
      readOnly = true;
    };
  };

  config._menu = {
    text = lib.pipe categories [
      builtins.attrValues
      (map (x: x._category))
      (lib.sortOn (x: x.order))
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
  };
}
