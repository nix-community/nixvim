{
  vimPlugins,
  writers,
  lib,
}:
lib.pipe "${vimPlugins.none-ls-nvim.src}/doc/builtins.json" [
  lib.importJSON
  (lib.mapAttrs (_: lib.attrNames))
  (writers.writeJSON "none-ls-sources.json")
]
