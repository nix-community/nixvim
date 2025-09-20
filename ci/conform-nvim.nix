{
  vimPlugins,
  lib,
  writeText,
}:
lib.pipe "${vimPlugins.conform-nvim}/lua/conform/formatters" [
  builtins.readDir
  builtins.attrNames
  (builtins.filter (lib.hasSuffix ".lua"))
  (map (lib.removeSuffix ".lua"))
  builtins.toJSON
  (writeText "conform-formatters")
]
