# This file isn't (currently) part of `lib.nixvim`, but is used directly by `efmls` and `none-ls` pkg lists
lib: rec {
  # Produces an attrset of { ${name} = name; }
  topLevel = names: lib.genAttrs names lib.id;

  # Produces an attrset of { ${name} = null; }
  nullAttrs = names: lib.genAttrs names (_: null);

  # Produces an attrset of { ${name} = [ scope name ]; }
  # Where the "scope" is the (nested) attr names,
  # and "name" is the value.
  # If the name value is a list, it will be expanded into multiple attrs.
  scoped = lib.concatMapAttrs (
    scope: v:
    if builtins.isAttrs v then
      lib.mapAttrs (_: loc: [ scope ] ++ loc) (scoped v)
    else
      lib.genAttrs (lib.toList v) (name: [
        scope
        name
      ])
  );
}
