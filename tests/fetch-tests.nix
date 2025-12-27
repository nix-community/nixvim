{
  lib,
  pkgs,
}:
let
  # Import a test file into the form { name = ""; file = ""; cases = {}; }
  handleTestFile =
    file: namespace:
    let
      fnOrAttrs = import file;
    in
    {
      inherit file;
      name = lib.strings.concatStringsSep "-" namespace;
      cases =
        if builtins.isFunction fnOrAttrs then
          # Call the function
          fnOrAttrs (
            builtins.intersectAttrs (builtins.functionArgs fnOrAttrs) {
              inherit pkgs lib;
            }
          )
        else
          fnOrAttrs;
    };

  # Recurse into all directories, extracting files as we find them.
  # This returns a list of { name; file; cases;  } attrsets.
  fetchTests =
    testPath: namespace:
    let
      # Handle an entry from readDir
      # - If it is a regular nix file, import its content
      # - If it is a directory, continue recursively
      handleEntry =
        name: type:
        let
          file = /${testPath}/${name};
        in
        if type == "regular" then
          lib.optional (lib.hasSuffix ".nix" name) (
            handleTestFile file (
              namespace ++ lib.optional (name != "default.nix") (lib.removeSuffix ".nix" name)
            )
          )
        else
          fetchTests file (namespace ++ [ name ]);
    in
    lib.pipe testPath [
      builtins.readDir
      (lib.filterAttrs (n: v: v != "symlink"))
      (lib.mapAttrsToList handleEntry)
      builtins.concatLists
    ];
in
root: fetchTests root [ ]
