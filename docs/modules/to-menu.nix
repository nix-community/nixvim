{
  lib,
  optionNames,
}:
/**
  The default `toMenu` function renders a page node into a menu subtree.
*/
{
  page,
  prefix ? [ ],
  indent ? "",
  nested ? true,
}:
let
  inherit (page._page) loc target;
  count = page._page.children;

  # Only add node to the menu if it has content or multiple children
  showInMenu = target != "" || count > 1;
  nextPrefix = if showInMenu then loc else prefix;
  nextIndent = if showInMenu && nested then indent + "  " else indent;

  children = removeAttrs page optionNames;
  submenu = lib.pipe children [
    builtins.attrValues
    (map (
      subpage:
      page._page.toMenu {
        inherit nested;
        page = subpage;
        indent = nextIndent;
        prefix = nextPrefix;
      }
    ))
  ];

  loc' = if lib.lists.hasPrefix prefix loc then lib.lists.drop (builtins.length prefix) loc else loc;
  menuText = lib.attrsets.showAttrPath loc';
  menuitem = lib.optionals showInMenu [
    (indent + lib.optionalString nested "- " + "[${menuText}](${target})")
  ];
in
builtins.concatStringsSep "\n" (menuitem ++ submenu)
