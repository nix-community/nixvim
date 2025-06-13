{
  vimPlugins,
  lib,
  writeText,
}:
let
  builtinSources = lib.trivial.importJSON "${vimPlugins.none-ls-nvim.src}/doc/builtins.json";
  builtinSourceNames = lib.mapAttrs (_: lib.attrNames) builtinSources;
in
writeText "none-ls-sources.nix" (
  "# WARNING: DO NOT EDIT\n"
  + "# This file is generated with packages.<system>.none-ls-builtins, which is run automatically by CI\n"
  + (lib.generators.toPretty { } builtinSourceNames)
)
