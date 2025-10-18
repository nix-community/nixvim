# TODO: make all the types support raw lua
lib:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;

  rustAnalyzerOptions = lib.importJSON ../../../generated/rust-analyzer-options.json;

  mkRustAnalyzerType =
    { kind, ... }@typeInfo:
    if kind == "enum" then
      types.enum typeInfo.values
    else if kind == "oneOf" then
      types.oneOf (lib.map mkRustAnalyzerType typeInfo.subTypes)
    else if kind == "list" then
      types.listOf (mkRustAnalyzerType typeInfo.item)
    else if kind == "number" then
      let
        inherit (typeInfo) minimum maximum;
      in
      if minimum != null && maximum != null then
        types.numbers.between minimum maximum
      else if minimum != null then
        types.addCheck types.number (x: x >= minimum)
      else if maximum != null then
        types.addCheck types.number (x: x <= maximum)
      else
        types.number
    else if kind == "integer" then
      let
        inherit (typeInfo) minimum maximum;
      in
      if minimum != null && maximum != null then
        types.ints.between minimum maximum
      else if minimum != null then
        types.addCheck types.int (x: x >= minimum)
      else if maximum != null then
        types.addCheck types.int (x: x <= maximum)
      else
        types.int
    else if kind == "object" then
      types.attrsOf types.anything
    else if kind == "submodule" then
      types.submodule {
        options = lib.mapAttrs (
          _: ty:
          lib.mkOption {
            type = mkRustAnalyzerType ty;
            description = "";
          }
        ) typeInfo.options;
      }
    else if kind == "string" then
      types.str
    else if kind == "boolean" then
      types.bool
    else
      throw "Unknown type: ${kind}";

  mkNixOption =
    {
      description,
      pluginDefault,
      type,
    }:
    defaultNullOpts.mkNullable' {
      inherit description pluginDefault;
      type = mkRustAnalyzerType type;
    };

  nestOpt =
    opt: value:
    let
      parts = lib.strings.splitString "." opt;
    in
    lib.setAttrByPath parts value;

  nestedNixOptions = lib.mapAttrsToList (
    name: value: nestOpt name (mkNixOption value)
  ) rustAnalyzerOptions;
in
(builtins.foldl' lib.recursiveUpdate { } nestedNixOptions).rust-analyzer
