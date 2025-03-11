{
  lib,
  config,
  ...
}:
{
  imports = [
    ./sections.nix
  ];

  options.docs.menu.src = lib.mkOption {
    type = lib.types.lines;
    description = ''
      MDBook SUMMARY menu. Generated from `docs.pages.<name>.menu`.

      See MDBook's [SUMMARY.md](https://rust-lang.github.io/mdBook/format/summary.html) docs.
    '';
    readOnly = true;
  };

  config.docs.menu.src = lib.pipe config.docs.menu.sections [
    builtins.attrValues
    (lib.sortOn (section: section.order))
    (builtins.catAttrs "text")
    (builtins.filter (text: text != null))
    lib.mkMerge
  ];
}
