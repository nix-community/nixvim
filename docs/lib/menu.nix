{
  lib,
  pages,
  indentSize ? "  ",
}:
let
  pageToLines =
    indent: parent: node:
    let

      children = lib.pipe node [
        (lib.flip builtins.removeAttrs [ "_page" ])
        builtins.attrValues
      ];
      # Only add node to the menu if it has content or multiple children
      useNodeInMenu = node._page.target != "" || node._page.children > 1;
      nextParent = if useNodeInMenu then node else parent;
      nextIndent = if useNodeInMenu then indent + indentSize else indent;
      loc = lib.lists.removePrefix (parent._page.loc or [ ]) node._page.loc;
      menuName = lib.attrsets.showAttrPath loc;
    in
    lib.optional useNodeInMenu "${indent}- [${menuName}](${node._page.target})"
    ++ lib.optionals (children != [ ]) (
      builtins.concatMap (pageToLines nextIndent nextParent) children
    );
in
lib.pipe pages [
  builtins.attrValues
  (builtins.concatMap (pageToLines "" null))
  lib.concatLines
]
