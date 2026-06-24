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

  contentType = lib.types.coercedTo lib.types.path (file: { inherit file; }) (
    lib.types.attrTag {
      file = lib.mkOption {
        description = "A markdown file.";
        type = lib.types.path;
      };
      text = lib.mkOption {
        description = "Lines of markdown.";
        type = lib.types.lines;
      };
      functions = lib.mkOption {
        description = "Nix file to scan for RFC145 doc comments.";
        type = lib.types.submodule {
          options.file = lib.mkOption {
            type = lib.types.path;
            description = "Nix file.";
          };
          options.loc = lib.mkOption {
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
        };
      };
      options = lib.mkOption {
        description = ''
          Set of options or list of option docs-templates.

          If an attrset is provided, it will be coerced using `lib.options.optionAttrSetToDocList`.
        '';
        type = lib.types.raw;
        apply = opts: if builtins.isAttrs opts then lib.options.optionAttrSetToDocList opts else opts;
      };
    }
  );
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
      default = lib.optionalString (cfg.content != [ ]) (
        lib.concatStringsSep "/" (cfg.loc ++ [ "index.md" ])
      );
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
    content = lib.mkOption {
      type = lib.types.listOf contentType;
      default = [ ];
      description = "Optional content sections rendered after the title.";
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
    pages = lib.mkOption {
      type = lib.types.listOf lib.types.raw;
      description = "This page, its children, their children, etc.";
      readOnly = true;
    };
  };

  config._page = {
    toMenu = import ./to-menu.nix {
      inherit lib;
      optionNames = builtins.attrNames options;
    };

    pages = lib.pipe options [
      builtins.attrNames
      (removeAttrs config)
      builtins.attrValues
      (lib.concatMap (x: x._page.pages))
      (children: [ cfg ] ++ children)
    ];
  };
}
