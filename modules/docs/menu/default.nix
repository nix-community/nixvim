{
  lib,
  config,
  ...
}:
let
  sortedMenuSections = lib.sortOn (section: section.order) (
    builtins.attrValues config.docs.menu.sections
  );
in
{
  imports = [
    ./sections.nix
  ];

  options.docs.menu.src = lib.mkOption {
    type = lib.types.lines;
    description = ''
      MDBook SUMMARY menu. Generated from pages defined in
      ${lib.concatMapStringsSep ", " (name: "`docs.${name}`") config.docs._allInputs}.

      See MDBook's [SUMMARY.md](https://rust-lang.github.io/mdBook/format/summary.html) docs.
    '';
    readOnly = true;
  };

  config.docs.menu.src = lib.mkMerge (
    builtins.filter (text: text != null) (builtins.catAttrs "text" sortedMenuSections)
  );
}
