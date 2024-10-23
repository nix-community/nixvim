# TODO: make all the types support raw lua
lib:
let
  rustAnalyzerOptions = import ../../../generated/rust-analyzer.nix;

  mkRustAnalyzerType =
    { kind, ... }@typeInfo:
    if kind == "enum" then
      lib.types.enum typeInfo.values
    else if kind == "oneOf" then
      lib.types.oneOf (lib.map mkRustAnalyzerType typeInfo.subTypes)
    else if kind == "list" then
      lib.types.listOf (mkRustAnalyzerType typeInfo.item)
    else if kind == "number" then
      let
        inherit (typeInfo) minimum maximum;
      in
      if minimum != null && maximum != null then
        lib.types.numbers.between minimum maximum
      else if minimum != null then
        lib.types.addCheck lib.types.number (x: x >= minimum)
      else if maximum != null then
        lib.types.addCheck lib.types.number (x: x <= maximum)
      else
        lib.types.number
    else if kind == "integer" then
      let
        inherit (typeInfo) minimum maximum;
      in
      if minimum != null && maximum != null then
        lib.types.ints.between minimum maximum
      else if minimum != null then
        lib.types.addCheck lib.types.int (x: x >= minimum)
      else if maximum != null then
        lib.types.addCheck lib.types.int (x: x <= maximum)
      else
        lib.types.int
    else if kind == "object" then
      lib.types.attrsOf lib.types.anything
    else if kind == "submodule" then
      lib.types.submodule {
        options = lib.mapAttrs (
          _: ty:
          lib.mkOption {
            type = mkRustAnalyzerType ty;
            description = "";
          }
        ) typeInfo.options;
      }
    else if kind == "string" then
      lib.types.str
    else if kind == "boolean" then
      lib.types.bool
    else
      throw "Unknown type: ${kind}";

  mkNixOption =
    {
      description,
      pluginDefault,
      type,
    }:
    lib.nixvim.defaultNullOpts.mkNullable' {
      inherit description pluginDefault;
      type = mkRustAnalyzerType type;
    };

  nestOpt =
    opt: value:
    let
      parts = lib.strings.splitString "." opt;
    in
    lib.setAttrByPath parts value;

  nestedNixOptions = lib.attrsets.mapAttrsToList (
    name: value: nestOpt name (mkNixOption value)
  ) rustAnalyzerOptions;
in
(builtins.foldl' lib.attrsets.recursiveUpdate { } nestedNixOptions).rust-analyzer
