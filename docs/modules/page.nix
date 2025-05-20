# This module represents a node in a tree of pages.
# Its freeformType is is recursive: attrs of another node submodule.
{
  lib,
  prefix,
  name,
  config,
  options,
  ...
}:
{
  freeformType = lib.types.attrsOf (
    lib.types.submoduleWith {
      specialArgs.prefix = prefix ++ [ name ];
      modules = [ ./page.nix ];
    }
    // {
      description = "page submodule";
      descriptionClass = "noun";
      # Alternative to `visible = "shallow"`, avoid inf-recursion when collecting options for docs
      getSubOptions = _: { };
    }
  );

  # The _page option contains options for this page node
  imports = [
    ./page-options.nix
  ];

  config = {
    # Ensure the `prefix` arg exists
    # Usually shadowed by `specialArgs.prefix`
    _module.args.prefix = [ ];

    _page = {
      # Freeform definitions are children; count definitions without a
      # corresponding option
      children = lib.pipe config [
        builtins.attrNames
        (lib.count (name: !(options ? ${name})))
        lib.mkForce
      ];
    };
  };
}
