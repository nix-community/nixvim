{ lib }:
let
  inherit (lib) types;
  inherit (lib.nixvim) lua-types;

  # Primitive types that can be represented in lua
  primitives = {
    inherit (types)
      bool
      float
      int
      path
      str
      ;
  };
in
{
  anything = types.either lua-types.primitive (lua-types.tableOf lua-types.anything) // {
    description = "lua value";
    descriptionClass = "noun";
  };

  # TODO: support merging list+attrs -> unkeyedAttrs
  tableOf =
    elemType:
    assert lib.strings.hasPrefix "lua" elemType.description;
    types.oneOf [
      (types.listOf elemType)
      (types.attrsOf elemType)
      types.luaInline
      types.rawLua
    ]
    // {
      description = "lua table of ${
        lib.types.optionDescriptionPhrase (class: class == "noun" || class == "composite") elemType
      }";
      descriptionClass = "composite";
    };

  primitive =
    types.nullOr (
      types.oneOf (
        [
          types.luaInline
          types.rawLua
        ]
        ++ builtins.attrValues primitives
      )
    )
    // {
      description = "lua primitive";
      descriptionClass = "noun";
    };
}
// builtins.mapAttrs (
  _: wrappedType:
  types.oneOf [
    wrappedType
    types.luaInline
    types.rawLua
  ]
  // {
    description = "lua ${wrappedType.description}";
    descriptionClass = "noun";
  }
) primitives
