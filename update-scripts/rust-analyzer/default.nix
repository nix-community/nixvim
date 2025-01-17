#
# This derivation creates a Nix file that describes the Nix module that needs to be instantiated
#
# The create file is of the form:
#
# {
#   "<rust-analyzer.option.name>" = {
#      description = "<option description>";
#      type = {
#          kind = "<name of the type>";
#          # Other values depending on the kind, like values for enum or subTypes for oneOf
#      };
#   };
# }
#
{
  lib,
  rust-analyzer,
  writeText,
  pandoc,
  runCommand,
}:
let
  packageJSON = "${rust-analyzer.src}/editors/code/package.json";
  options = (lib.importJSON packageJSON).contributes.configuration;

  generatedStart = lib.lists.findFirstIndex (
    e: e == { title = "$generated-start"; }
  ) (throw "missing generated start") options;
  generatedEnd = lib.lists.findFirstIndex (
    e: e == { title = "$generated-end"; }
  ) (throw "missing generated end") options;

  # Extract only the generated properties, removing vscode specific options
  rustAnalyzerProperties = lib.lists.sublist (generatedStart + 1) (
    generatedEnd - generatedStart - 1
  ) options;

  mkRustAnalyzerOptionType =
    nullable: property_name: property:
    let
      inner =
        {
          type ? null,
          enum ? null,
          minimum ? null,
          maximum ? null,
          items ? null,
          anyOf ? null,
          properties ? null,
          # Not used in the function, but anyOf values contain it
          enumDescriptions ? null,
        }@property:
        if enum != null then
          {
            kind = "enum";
            values = enum;
          }
        else if anyOf != null then
          let
            possibleTypes = lib.filter (sub: !(sub.type == "null" && nullable)) anyOf;
          in
          {
            kind = "oneOf";
            subTypes = builtins.map (
              t: mkRustAnalyzerOptionType nullable "${property_name}-sub" t
            ) possibleTypes;
          }
        else
          (
            assert lib.assertMsg (type != null) "property is neither anyOf nor enum, it must have a type";
            if lib.isList type then
              (
                if lib.head type == "null" then
                  assert lib.assertMsg (
                    lib.length type == 2
                  ) "Lists starting with null are assumed to mean nullOr, so length 2";
                  let
                    innerType = property // {
                      type = lib.elemAt type 1;
                    };
                    inner = mkRustAnalyzerOptionType nullable "${property_name}-inner" innerType;
                  in
                  assert lib.assertMsg nullable "nullOr types are not yet handled";
                  inner
                else
                  let
                    innerTypes = builtins.map (
                      t: mkRustAnalyzerOptionType nullable "${property_name}-inner" (property // { type = t; })
                    ) type;
                  in
                  {
                    kind = "oneOf";
                    subTypes = innerTypes;
                  }
              )
            else if type == "array" then
              {
                kind = "list";
                item = mkRustAnalyzerOptionType false "${property_name}-item" items;
              }
            else if type == "number" || type == "integer" then
              {
                kind = type;
                inherit minimum maximum;
              }
            else if type == "object" && properties != null then
              {
                kind = "submodule";
                options = lib.mapAttrs (
                  name: value: mkRustAnalyzerOptionType false "${property_name}.${name}" value
                ) properties;
              }
            else if
              lib.elem type [
                "object"
                "string"
                "boolean"
              ]
            then
              { kind = type; }
            else
              throw "Unhandled value in ${property_name}: ${lib.generators.toPretty { } property}"
          );
    in
    builtins.addErrorContext "While creating type for ${property_name}:\n${lib.generators.toPretty { } property}" (
      inner property
    );

  mkRustAnalyzerOption =
    property_name:
    {
      # List all possible values so that we are sure no new values are introduced
      default,
      markdownDescription,
      enum ? null,
      enumDescriptions ? null,
      anyOf ? null,
      minimum ? null,
      maximum ? null,
      items ? null,
      # TODO: add this in the documentation ?
      uniqueItems ? null,
      type ? null,
    }:
    let
      filteredMarkdownDesc =
        # If there is a risk that the string contains an heading filter it out
        if lib.hasInfix "# " markdownDescription then
          builtins.readFile (
            runCommand "filtered-documentation" { inherit markdownDescription; } ''
              ${lib.getExe pandoc} -o $out -t markdown \
                --lua-filter=${./heading_filter.lua} <<<"$markdownDescription"
            ''
          )
        else
          markdownDescription;

      enumDesc =
        values: descriptions:
        let
          valueDesc = builtins.map ({ fst, snd }: ''- ${fst}: ${snd}'') (
            lib.lists.zipLists values descriptions
          );
        in
        ''
          ${filteredMarkdownDesc}

          Values:
          ${builtins.concatStringsSep "\n" valueDesc}
        '';
    in
    {
      type = mkRustAnalyzerOptionType true property_name {
        inherit
          type
          enum
          minimum
          maximum
          items
          anyOf
          enumDescriptions
          ;
      };
      pluginDefault = default;
      description =
        if
          enum == null && (anyOf == null || builtins.all (subProp: !(lib.hasAttr "enum" subProp)) anyOf)
        then
          ''
            ${filteredMarkdownDesc}
          ''
        else if enum != null then
          assert lib.assertMsg (anyOf == null) "enum + anyOf types are not yet handled";
          enumDesc enum enumDescriptions
        else
          let
            subEnums = lib.filter (lib.hasAttr "enum") anyOf;
            subEnum =
              assert lib.assertMsg (
                lib.length subEnums == 1
              ) "anyOf types may currently only contain a single enum";
              lib.head subEnums;
          in
          enumDesc subEnum.enum subEnum.enumDescriptions;
    };

  rustAnalyzerOptions = builtins.map (
    v:
    let
      props = lib.attrsToList v.properties;
      prop =
        assert lib.assertMsg (
          lib.length props == 1
        ) "Rust analyzer configuration items are only supported with a single element";
        lib.head props;
    in
    {
      "${prop.name}" = mkRustAnalyzerOption prop.name prop.value;
    }
  ) rustAnalyzerProperties;
in
writeText "rust-analyzer-options.nix" (
  "# WARNING: DO NOT EDIT\n"
  + "# This file is generated with packages.<system>.rust-analyzer-options, which is run automatically by CI\n"
  + (lib.generators.toPretty { } (lib.mergeAttrsList rustAnalyzerOptions))
)
