{
  lib,
  name,
  config,
  options,
  ...
}:
let
  cfg = config._category;

  pageType = lib.types.submoduleWith {
    modules = [ ./page.nix ];
  };

  pages = removeAttrs config (builtins.attrNames options);
in
{
  freeformType = lib.types.attrsOf pageType;

  options._category = {
    name = lib.mkOption {
      type = lib.types.str;
      default = name;
      defaultText = lib.literalMD "attribute name";
    };

    order = lib.mkOption {
      type = lib.types.int;
      default = 100;
      description = "Priority for where this category will appear in the menu.";
    };

    type = lib.mkOption {
      type = lib.types.enum [
        "prefix"
        "normal"
        "suffix"
      ];
      default = "normal";
      description = ''
        The kind of mdbook chapters this category contains.

        **Prefix Chapter**
        : Before the main numbered chapters, prefix chapters can be added that
          will not be numbered. This is useful for forewords, introductions, etc.
          There are, however, some constraints.
          Prefix chapters cannot be nested; they should all be on the root level.
          And you cannot add prefix chapters once you have added numbered chapters.

        **Normal Chapter**
        : Called a "Numbered Chapter" in the MDBook docs.
          Numbered chapters outline the main content of the book and can be
          nested, resulting in a nice hierarchy (chapters, sub-chapters, etc.).

        **Suffix Chapter**
        : Like prefix chapters, suffix chapters are unnumbered, but they come
          after numbered chapters.

        See <https://rust-lang.github.io/mdBook/format/summary.html>.
      '';
    };

    text = lib.mkOption {
      type = lib.types.str;
      description = "The rendered menu.";
      readOnly = true;
    };
  };

  config._category = {
    text = lib.optionalString (pages != { }) ''
      # ${cfg.name}

      ${lib.pipe pages [
        builtins.attrValues
        (map (
          page:
          page._page.toMenu {
            nested = cfg.type == "normal";
            indent = "";
            prefix = [ ];
            inherit page;
          }
        ))
        (builtins.concatStringsSep "\n")
      ]}
    '';
  };
}
