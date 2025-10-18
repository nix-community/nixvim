{
  lib,
  writers,
  vimPlugins,
}:
let
  tools = lib.importJSON "${vimPlugins.efmls-configs-nvim.src}/doc/supported-list.json";
  languages = lib.attrNames tools;

  toLangTools' = lang: kind: lib.map (lib.getAttr "name") (tools.${lang}.${kind} or [ ]);

  miscLinters = toLangTools' "misc" "linters";
  miscFormatters = toLangTools' "misc" "formatters";

  sources =
    let
      # Group languages by lowercase name and merge their tools
      groupedLanguages = builtins.groupBy (lang: lib.toLower lang) languages;
      mergedLanguages = lib.mapAttrs (
        lowerLang: langList:
        let
          # Use the first language as the canonical name but prefer lowercase if available
          canonicalLang = if lib.elem lowerLang langList then lowerLang else lib.head langList;
          # Merge all tools from all case variations
          allLinters = lib.unique (lib.concatMap (lang: toLangTools' lang "linters") langList);
          allFormatters = lib.unique (lib.concatMap (lang: toLangTools' lang "formatters") langList);
        in
        {
          name = canonicalLang;
          value = {
            linter = {
              lang = canonicalLang;
              possible = allLinters ++ miscLinters;
            };
            formatter = {
              lang = canonicalLang;
              possible = allFormatters ++ miscFormatters;
            };
          };
        }
      ) groupedLanguages;
    in
    (lib.listToAttrs (lib.attrValues mergedLanguages))
    // {
      all = {
        linter = {
          lang = "all languages";
          possible = miscLinters;
        };
        formatter = {
          lang = "all languages";
          possible = miscFormatters;
        };
      };
    };
in
writers.writeJSON "efmls-configs-sources.json" sources
