{
  lib,
  pkgs,
  ...
}:
let
  user-guide = ../../../docs/user-guide;

  sourceTransformers = {
    config-examples =
      template:
      pkgs.callPackage ./user-configs.nix {
        inherit template;
      };
  };
in
{
  docs.pages = lib.concatMapAttrs (
    name: type:
    let
      title = lib.removeSuffix ".md" name;
      transformer = sourceTransformers.${title} or lib.id;
    in
    lib.optionalAttrs (type == "regular") {
      "user-guide/${title}" = {
        menu.section = "user-guide";
        # TODO: define user-facing titles to show in the menu...
        menu.location = [ title ];
        source = transformer "${user-guide}/${name}";
      };
    }
  ) (builtins.readDir user-guide);
}
