{ lib, ... }:
let
  inherit (lib) mkRenamedOptionModule mkRemovedOptionModule;
in
{
  imports = [
    # Renames
    (mkRenamedOptionModule [ "plugins" "lint" "lintersByFt" ] [ "plugins" "lint" "linters_by_ft" ])

    # Removals
    (mkRemovedOptionModule [
      "plugins"
      "lint"
      "customLinters"
    ] "plugins.lint.customLinters option was removed, use linters instead.")
  ];
}
