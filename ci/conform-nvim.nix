{
  vimPlugins,
  lib,
  writeText,
}:
let
  formattersDir = "${vimPlugins.conform-nvim}/lua/conform/formatters";
  formatterFiles = builtins.attrNames (builtins.readDir formattersDir);
  supportedFormatters =
    let
      luaFiles = builtins.filter (lib.hasSuffix ".lua") formatterFiles;
    in
    map (lib.removeSuffix ".lua") luaFiles;
in
writeText "conform-formatters.nix" (
  "# WARNING: DO NOT EDIT\n"
  + "# This file is generated with packages.<system>.conform-formatters, which is run automatically by CI\n"
  + (lib.generators.toPretty { } supportedFormatters)
)
