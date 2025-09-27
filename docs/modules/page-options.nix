{
  lib,
  prefix,
  name,
  config,
  options,
  ...
}:
let
  cfg = config._page;
  opts = options._page;
in
{
  options._page = {
    loc = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Page's location in the menu.";
      default = prefix ++ [ name ];
      defaultText = lib.literalExpression "prefix ++ [ name ]";
      readOnly = true;
    };
    target = lib.mkOption {
      type = lib.types.str;
      default = lib.optionalString cfg.hasContent (lib.concatStringsSep "/" (cfg.loc ++ [ "index.md" ]));
      defaultText = lib.literalMD ''
        `""` if page has no content, otherwise a filepath derived from the page's `loc`.
      '';
      description = "Where to render content and link menu entries.";
    };
    title = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Page's heading title.";
    };
    text = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = null;
      description = "Optional markdown text to include after the title.";
    };
    source = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Optional markdown file to include after the title.";
    };
    functions.file = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Optional nix file to scan for RFC145 doc comments.";
    };
    functions.loc = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = if lib.lists.hasPrefix [ "lib" ] cfg.loc then builtins.tail cfg.loc else cfg.loc;
      defaultText = lib.literalMD ''
        `loc`'s attrpath, without any leading "lib"
      '';
      description = ''
        Optional attrpath where functions are defined.
        Provided to `nixdoc` as `--category`.

        Will scan `lib` for attribute locations in the functions set at this attrpath.

        Used in conjunction with `nix`.
      '';
    };
    options = lib.mkOption {
      type = lib.types.nullOr lib.types.raw;
      default = null;
      apply = opts: if builtins.isAttrs opts then lib.options.optionAttrSetToDocList opts else opts;
      description = ''
        Optional set of options or list of option docs-templates.

        If an attrset is provided, it will be coerced using `lib.options.optionAttrSetToDocList`.
      '';
    };
    toMenu = lib.mkOption {
      type = lib.types.functionTo lib.types.str;
      description = ''
        A function to render the menu for this sub-tree.

        Typically, this involves invoking `_page.toMenu` for all children.

        **Inputs**

        `settings`
        : `nested`
          : Whether this menu category supports nesting.

          `indent`
          : The indentation to use before non-empty lines.

          `page`
          : This page node.

          `prefix`
          : The menu loc prefix, to be omitted from menu entry text.
            Usually the `loc` of the parent page node.
      '';
    };
    children = lib.mkOption {
      type = lib.types.ints.unsigned;
      description = ''
        The number of child pages.
      '';
      readOnly = true;
    };
    hasContent = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Whether this page has any docs content.

        When `false`, this page represents an _empty_ menu entry.
      '';
      readOnly = true;
    };
  };

  config._page = {
    source = lib.mkIf (cfg.text != null) (
      lib.mkDerivedConfig opts.text (builtins.toFile "docs-${lib.attrsets.showAttrPath cfg.loc}-text.md")
    );

    hasContent = builtins.any (x: x != null) [
      cfg.source # markdown
      cfg.functions.file # doc-comments
      cfg.options # module options
    ];

    toMenu = import ./to-menu.nix {
      inherit lib;
      optionNames = builtins.attrNames options;
    };
  };
}
