{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (config.docs.menu)
    sections
    ;

  docsPageModule =
    {
      name,
      config,
      options,
      ...
    }:
    let
      derivationName = builtins.replaceStrings [ "/" ] [ "-" ] name;
    in
    {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = "Whether to enable this page/menu item.";
          default = true;
          example = false;
        };
        target = lib.mkOption {
          type = lib.types.str;
          description = ''
            The target filepath, relative to the root of the docs.
          '';
          default = lib.optionalString (name != "") (name + "/") + "index.md";
          defaultText = lib.literalMD ''
            `<name>` joined with `"index.md"`. Separated by `"/"` if `<name>` is non-empty.
          '';
        };
        text = lib.mkOption {
          type = with lib.types; nullOr lines;
          default = null;
          description = "Text of the file.";
        };
        source = lib.mkOption {
          type = with lib.types; nullOr path;
          default = null;
          description = ''
            Markdown page. Set to null to create a menu entry without a corresponding file.
          '';
        };
        menu.location = lib.mkOption {
          type = with lib.types; listOf str;
          description = ''
            A location path that represents the page's position in the menu tree.

            The text displayed in the menu is derived from this value,
            after the location of any parent nodes in the tree is removed.

            For example, if this page has the location `[ "foo" "bar" ]`
            and there is another page with the location `[ "foo" ]`,
            then the menu will render as:
            ```markdown
            - foo
              - bar
            ```

            However if there was no other page with the `[ "foo" ]` location,
            the menu would instead render as:
            ```markdown
            - foo.bar
            ```
          '';
          default =
            let
              list = lib.splitString "/" config.target;
              last = lib.last list;
              rest = lib.dropEnd 1 list;
            in
            if last == "index.md" then
              rest
            else if lib.hasSuffix ".md" last then
              rest ++ [ (lib.removeSuffix ".md" last) ]
            else
              list;
          defaultText = lib.literalMD ''
            `target`, split by `"/"`, with any trailing `"index.md` or `".md"` suffixes removed.
          '';
        };
        menu.section = lib.mkOption {
          type = lib.types.enum (builtins.attrNames sections);
          description = ''
            Determines the menu section.

            Must be a section defined in `docs.menu.sections`.
          '';
        };
      };

      config.source = lib.mkIf (config.text != null) (
        lib.mkDerivedConfig options.text (builtins.toFile derivationName)
      );
    };

  # NOTE: using submoduleWith to avoid shorthandOnlyDefinesConfig
  docsPageType = lib.types.submoduleWith {
    modules = [ docsPageModule ];
  };
in
{
  options.docs = {
    pages = lib.mkOption {
      type = with lib.types; lazyAttrsOf docsPageType;
      default = { };
      description = ''
        Pages to include in the docs.
      '';
    };
    src = lib.mkOption {
      type = lib.types.package;
      description = "All source files for the docs.";
      readOnly = true;
    };
  };

  config.docs = {
    # A directory with all the files in it
    src = pkgs.callPackage ./collect-sources.nix {
      pages = builtins.filter (page: page.source or null != null) (builtins.attrValues config.docs.pages);
    };
  };
}
