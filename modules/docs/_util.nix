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

  transformOption =
    let
      root = builtins.toString ../../.;
      mkGitHubDeclaration = user: repo: branch: subpath: {
        url = "https://github.com/${user}/${repo}/blob/${branch}/${subpath}";
        name = "<${repo}/${subpath}>";
      };
      transformDeclaration =
        decl:
        if lib.hasPrefix root (builtins.toString decl) then
          mkGitHubDeclaration "nix-community" "nixvim" "main" (
            lib.removePrefix "/" (lib.strings.removePrefix root (builtins.toString decl))
          )
        else if decl == "lib/modules.nix" then
          mkGitHubDeclaration "NixOS" "nixpkgs" "master" decl
        else
          decl;
    in
    opt: opt // { declarations = builtins.map transformDeclaration opt.declarations; };

  docsPageModule =
    { name, config, ... }:
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
        source = lib.mkOption {
          type = with lib.types; nullOr path;
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
    };
in
{
  options.docs._utils = lib.mkOption {
    type = with lib.types; lazyAttrsOf raw;
    description = "internal utils, modules, functions, etc";
    default = { };
    internal = true;
    visible = false;
  };

  config.docs._utils = {
    # A liberal type that permits any superset of docsPageModule
    docsPageLiberalType = lib.types.submodule [
      { _module.check = false; }
      docsPageModule
    ];

    /**
      Uses `lib.optionAttrSetToDocList` to produce a list of docs-options.

      A doc-option has the following attrs, as expected by `nixos-render-docs`:

      ```
      {
        loc,
        name, # rendered with `showOption loc`
        description,
        declarations,
        internal,
        visible, # normalised to a boolean
        readOnly,
        type, # normalised to `type.description`
        default,? # rendered with `lib.options.renderOptionValue`
        example,? # rendered with `lib.options.renderOptionValue`
        relatedPackages,?
      }
      ```

      Additionally, sub-options are recursively flattened into the list,
      unless `visible == "shallow"` or `visible == false`.

      This function extends `lib.optionAttrSetToDocList` by also filtering out
      invisible and internal options, and by applying Nixvim's `transformOption`
      function.

      The implementation is based on `pkgs.nixosOptionsDoc`:
      https://github.com/NixOS/nixpkgs/blob/e2078ef3/nixos/lib/make-options-doc/default.nix#L117-L126
    */
    mkOptionList = lib.flip lib.pipe [
      (lib.flip builtins.removeAttrs [ "_module" ])
      lib.optionAttrSetToDocList
      (builtins.map transformOption)
      (builtins.filter (opt: opt.visible && !opt.internal))
      # TODO: consider supporting `relatedPackages`
      # See https://github.com/NixOS/nixpkgs/blob/61235d44/lib/options.nix#L103-L104
      # and https://github.com/NixOS/nixpkgs/blob/61235d44/nixos/lib/make-options-doc/default.nix#L128-L165
    ];

    inherit docsPageModule;
  };
}
