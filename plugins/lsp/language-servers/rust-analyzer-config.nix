lib: pkgs:
# Future improvements:
#   - extra documentation from anyOf types, they can have `enumDescriptions` that are valuable
with lib; let
  packageJson = "${pkgs.rust-analyzer.src}/editors/code/package.json";

  options =
    (trivial.importJSON packageJson)
    .contributes
    .configuration
    .properties;

  packageJsonTxt = strings.splitString "\n" (builtins.readFile packageJson);
  vscodeStart =
    lists.findFirstIndex (x: x == "        \"configuration\": {")
    (throw "no configuration")
    packageJsonTxt;
  vscodeEnd =
    lists.findFirstIndex (strings.hasInfix "generated-start") (throw "no generated start")
    packageJsonTxt;
  vscodeOptions = lists.sublist vscodeStart (vscodeEnd - vscodeStart) packageJsonTxt;

  vscodeOptionNames =
    builtins.map
    (x: strings.removeSuffix "\": {" (strings.removePrefix "                \"" x))
    (lists.filter (strings.hasPrefix "                \"rust-analyzer.")
      vscodeOptions);

  rustAnalyzerOptions =
    builtins.removeAttrs options
    (vscodeOptionNames ++ ["\$generated-start" "\$generated-end"]);

  nullType = mkOptionType {
    name = "nullType";
    description = "null";
    descriptionClass = "noun";
    merge = mergeEqualOption;
    check = e: e == null;
  };

  mkRustAnalyzerType = opt: {
    type,
    enum ? null,
    minimum ? null,
    maximum ? null,
    items ? null,
    anyOf ? null,
    uniqueItems ? null,
    # unused, but for exhaustivness
    enumDescriptions ? null,
  } @ def:
    if enum != null
    then types.enum enum
    else if anyOf != null
    then types.oneOf (builtins.map (mkRustAnalyzerType opt) anyOf)
    else if builtins.isList type
    then
      if builtins.length type == 2 && builtins.head type == "null"
      then types.nullOr (mkRustAnalyzerType opt (def // {type = builtins.elemAt type 1;}))
      else types.oneOf (builtins.map (t: mkRustAnalyzerType opt (def // {type = t;})) type)
    else if type == "boolean"
    then types.bool
    else if type == "object"
    then types.attrsOf types.anything
    else if type == "string"
    then types.str
    else if type == "null"
    then nullType
    else if type == "array"
    then
      types.listOf (
        mkRustAnalyzerType "${opt}-items"
        (
          if items == null
          then throw "null items with array type (in ${opt})"
          else items
        )
      )
    else if type == "number"
    then
      if minimum != null && maximum != null
      then types.numbers.between minimum maximum
      else if minimum != null
      then types.addCheck types.number (x: x >= minimum)
      else if maximum != null
      then types.addCheck types.number (x: x <= maximum)
      else types.number
    else if type == "integer"
    then
      if minimum != null && maximum != null
      then types.ints.between minimum maximum
      else if minimum != null
      then types.addCheck types.int (x: x >= minimum)
      else if maximum != null
      then types.addCheck types.int (x: x <= maximum)
      else types.int
    else throw "unhandled type `${builtins.toJSON type}` (in ${opt})";

  mkRustAnalyzerOption = opt: {
    default,
    markdownDescription,
    type ? null,
    anyOf ? null,
    # Enum types
    enum ? null,
    enumDescriptions ? null,
    # Int types
    minimum ? null,
    maximum ? null,
    # List types
    items ? null,
    uniqueItems ? false,
  }:
    mkOption {
      type = types.nullOr (mkRustAnalyzerType opt {
        inherit
          type
          enum
          minimum
          maximum
          items
          anyOf
          uniqueItems
          ;
      });
      default = null;
      description =
        if enum != null
        then let
          valueDesc = builtins.map ({
            fst,
            snd,
          }: ''- ${fst}: ${snd}'') (lists.zipLists enum enumDescriptions);
        in ''
          ${markdownDescription}

          Values:
          ${builtins.concatStringsSep "\n" valueDesc}

          ```nix
          ${generators.toPretty {} default}
          ```
        ''
        else ''
          ${markdownDescription}

          default:
          ```nix
          ${generators.toPretty {} default}
          ```
        '';
    };

  nixOptions = builtins.mapAttrs mkRustAnalyzerOption rustAnalyzerOptions;

  nestOpt = opt: value: let
    parts = strings.splitString "." opt;
  in
    builtins.foldl' (current: segment: {${segment} = current;}) value (lists.reverseList parts);

  nestedNixOptions = attrsets.mapAttrsToList nestOpt nixOptions;
in
  (builtins.foldl' attrsets.recursiveUpdate {} nestedNixOptions).rust-analyzer
