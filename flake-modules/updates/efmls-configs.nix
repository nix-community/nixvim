{
  lib,
  vimPlugins,
  writeText,
  pkgs,
}:
let
  tools = lib.trivial.importJSON "${vimPlugins.efmls-configs-nvim.src}/doc/supported-list.json";
  languages = lib.attrNames tools;

  toLangTools' = lang: kind: lib.map (lib.getAttr "name") (tools.${lang}.${kind} or [ ]);

  miscLinters = toLangTools' "misc" "linters";
  miscFormatters = toLangTools' "misc" "formatters";

  sources =
    (lib.listToAttrs (
      lib.map (
        lang:
        let
          toLangTools = toLangTools' lang;
        in
        {
          name = lang;
          value = {
            linter = {
              inherit lang;
              possible = (toLangTools "linters") ++ miscLinters;
            };
            formatter = {
              inherit lang;
              possible = (toLangTools "formatters") ++ miscFormatters;
            };
          };
        }
      ) languages
    ))
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

  inherit (import ../../plugins/lsp/language-servers/efmls-configs-pkgs.nix pkgs) packaged unpackaged;

  toolList = lib.lists.unique (
    lib.concatLists (
      lib.map ({ linter, formatter }: linter.possible ++ formatter.possible) (lib.attrValues sources)
    )
  );

  unknownTools = lib.filter (tool: !(lib.hasAttr tool packaged || lib.elem tool unpackaged)) toolList;
in
writeText "efmls-configs-sources.nix" (
  assert lib.assertMsg (lib.length unknownTools == 0)
    "The following tools are neither marked as unpackaged nor as packaged: ${
      lib.generators.toPretty { } unknownTools
    }";
  "# WARNING: DO NOT EDIT\n"
  + "# This file is generated with packages.<system>.efmls-configs-sources, which is run automatically by CI\n"
  + (lib.generators.toPretty { } sources)
)
