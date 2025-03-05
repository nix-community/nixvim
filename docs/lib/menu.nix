{
  lib,
  pageSpecs,
  indentSize ? "  ",
}:
let
  pageToLines =
    indent: parentName:
    {
      name,
      outFile ? "",
      pages ? { },
      ...
    }:
    let
      menuName = lib.strings.removePrefix (parentName + ".") name;
      children = builtins.attrValues pages;
      # Only add node to the menu if it has content or multiple children
      useNodeInMenu = outFile != "" || builtins.length children > 1;
      parentOfChildren = if useNodeInMenu then name else parentName;
    in
    lib.optional useNodeInMenu "${indent}- [${menuName}](${outFile})"
    ++ lib.optionals (children != [ ]) (
      builtins.concatMap (pageToLines (indent + indentSize) parentOfChildren) children
    );
in
lib.pipe pageSpecs [
  builtins.attrValues
  (builtins.concatMap (pageToLines "" ""))
  lib.concatLines
]
