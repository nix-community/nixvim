{
  vimPlugins,
  lib,
  writeText,
  pkgs,
}:
let
  inherit (import ../../plugins/none-ls/packages.nix pkgs) packaged noPackage unpackaged;

  builtinSources = lib.trivial.importJSON "${vimPlugins.none-ls-nvim.src}/doc/builtins.json";

  builtinSourceNames = lib.mapAttrs (_: lib.attrNames) builtinSources;

  toolNames = lib.unique (lib.flatten (lib.attrValues builtinSourceNames));

  undeclaredTool = lib.filter (
    name: !(lib.hasAttr name packaged || lib.elem name noPackage || lib.elem name unpackaged)
  ) toolNames;

  uselesslyDeclaredTool = lib.filter (name: !(lib.elem name toolNames)) (
    unpackaged ++ noPackage ++ (lib.attrNames packaged)
  );
in
assert lib.assertMsg (lib.length undeclaredTool == 0)
  "Undeclared tools: ${lib.generators.toPretty { } undeclaredTool}";
assert lib.assertMsg (lib.length uselesslyDeclaredTool == 0)
  "Tool is not supported upstream: ${lib.generators.toPretty { } uselesslyDeclaredTool}";
writeText "efmls-configs-sources.nix" (
  "# WARNING: DO NOT EDIT\n"
  + "# This file is generated with packages.<system>.none-ls-builtins, which is run automatically by CI\n"
  + (lib.generators.toPretty { } builtinSourceNames)
)
