{ lib, ... }:
{
  # Attribute may contain the following fields:
  #  - path: Path to the module, e.g. [ "plugins" "<name>" ]
  #  - description: A short description of the plugin
  #  - url: Url for the plugin
  #
  # We need to use an attrs instead of a submodule to handle the merge.
  options.meta.nixvimInfo = lib.mkOption {
    type = (lib.types.nullOr lib.types.attrs) // {
      # This will create an attrset of the form:
      #
      # { path.to.plugin.name = <info>; }
      #
      #
      # Where <info> is an attrset of the form:
      # {
      #   file = "path";
      #   description = null or "<DESCRIPTION>";
      #   url = null or "<URL>";
      # }
      merge =
        _: defs:
        lib.foldl'
          (
            acc: def:
            lib.recursiveUpdate acc (
              lib.setAttrByPath def.value.path (
                {
                  inherit (def) file;
                  _type = "nixvimInfo";
                }
                // builtins.removeAttrs def.value [ "path" ]
              )
            )
          )
          {
            plugins = { };
            colorschemes = { };
          }
          defs;
    };
    internal = true;
    default = null;
    description = ''
      Nixvim related information on the module
    '';
  };
}
