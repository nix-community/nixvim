{ lib, ... }:
let
  inherit (lib) mkRemovedOptionModule;
in
{
  imports = [
    (mkRemovedOptionModule [
      "plugins"
      "lint"
      "customLinters"
    ] "plugins.lint.customLinters option was removed, use linters instead.")
  ];
}
