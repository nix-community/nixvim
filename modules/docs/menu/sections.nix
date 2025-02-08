{
  lib,
  config,
  ...
}:
let
  # A set of menu sections, each mapped to a list of pages
  # { section = [page]; }
  pagesBySection = builtins.groupBy (page: page.menu.section) (builtins.attrValues config.docs.pages);

  # Converts a list of pages into a tree that defines the shape of the menu
  mkPagesTree =
    let
      # Produce a list of page nodes
      go =
        nodes: pages:
        if pages == [ ] then
          nodes
        else
          let
            page = builtins.head pages;
            remaining = lib.drop 1 pages;
            prefix = page.menu.location;

            # Partition the remaining pages by whether they are children of this page
            inherit (builtins.partition (p: lib.lists.hasPrefix prefix p.menu.location) remaining)
              right
              wrong
              ;

            node = page // {
              children = processChildren prefix right;
            };
          in
          go (nodes ++ [ node ]) wrong;

      # Recursively produce a tree of child pages
      processChildren =
        prefix: pages:
        pagesToAttrs (
          builtins.map (
            page:
            page
            // {
              menu = page.menu // {
                location = lib.lists.removePrefix prefix page.menu.location;
              };
            }
          ) (go [ ] pages)
        );

      posLength = page: builtins.length page.menu.location;
    in
    # Sort by location length _before_ using `go`
    # `go` assumes that parent positions come before child positions
    list: pagesToAttrs (go [ ] (lib.sortOn posLength list));

  # Convert a list of nodes into an attrset
  # The each page node's menu.location is used to derive its attr name
  pagesToAttrs =
    let
      getName = lib.concatStringsSep ".";
    in
    nodes:
    builtins.listToAttrs (
      builtins.map (node: {
        # TODO: allow pages to define their own link-text?
        name = getName node.menu.location;
        value = node;
      }) nodes
    );

  # Render tree of pages to a markdown summary menu
  renderMenuPages =
    bullet: pages:
    let
      renderLine =
        indent: page:
        let
          inherit (page.menu) location;
          text = lib.showOption location;
          # FIXME: mdbook complains "chapter file not found" when creating a dangling link,
          # but what if we _want_ to do so, e.g. to link to `search/index.html` or to an external site?
          # Maybe dangling/external links are only permitted when they don't end with `.md` ?
          target = lib.optionalString (page.source != null) page.target;
        in
        indent + bullet + "[${text}](${target})";
      renderNode =
        indent: page:
        [ (renderLine indent page) ]
        ++ lib.optionals (page ? children) (
          builtins.concatMap (renderNode (indent + "  ")) (builtins.attrValues page.children)
        );
    in
    builtins.concatMap (renderNode "") (builtins.attrValues pages);

  sectionType = lib.types.submodule (
    { name, config, ... }:
    {
      options = {
        displayName = lib.mkOption {
          type = lib.types.str;
          description = "The section's display name.";
          default = name;
        };
        markdown = lib.mkOption {
          type = lib.types.str;
          description = "The section's display name.";
          default = ''
            # ${config.displayName}
          '';
          defaultText = lib.literalExpression ''"# ''${config.displayName}"'';
        };
        order = lib.mkOption {
          type = lib.types.ints.unsigned;
          description = "Ordering priority";
          default = 1000;
        };
        nesting = lib.mkOption {
          type = lib.types.bool;
          description = "Whether pages in this section can be nested within other menu items.";
          default = true;
        };
        pages = lib.mkOption {
          # NOTE: Use attrs here to avoid defaults & internal definitions from the docsPageType
          # TODO: Maybe don't expose this as a module option at all? A privately scoped binding would be fine.
          type = with lib.types; listOf attrs;
          description = "Pages that belong to this section.";
          visible = "shallow";
          readOnly = true;
        };
        text = lib.mkOption {
          type = with lib.types; nullOr lines;
          description = "Lines to include in the menu.";
          readOnly = true;
        };
      };
      config = {
        pages = pagesBySection.${name} or [ ];
        text =
          let
            pages = (if config.nesting then mkPagesTree else pagesToAttrs) config.pages;
            bullet = lib.optionalString config.nesting "- ";
            text = lib.mkMerge (
              [ config.markdown ]
              ++ renderMenuPages bullet pages
              ++ [
                ""
              ]
            );
          in
          if config.pages == [ ] then null else text;
      };
    }
  );
in
{
  options.docs.menu.sections = lib.mkOption {
    type = with lib.types; attrsOf sectionType;
    description = ''
      A set of menu sections/parts that pages can belong to.
    '';
    defaultText = { };
  };

  config.docs.menu.sections = {
    header = {
      displayName = "Menu";
      nesting = false;
      order = 0;
    };
    user-guide = {
      displayName = "User guide";
      order = 100;
    };
    platforms = {
      displayName = "Platforms-specific options";
      order = 2000;
    };
    options = {
      displayName = "Options";
      order = 5000;
    };
    footer = {
      displayName = "";
      markdown = ''
        #

        ---
      '';
      nesting = false;
      order = 10000;
    };
  };
}
