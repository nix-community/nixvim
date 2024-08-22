{
  root,
  lib,
  pkgs,
  helpers,
}:
let
  # Import a test file into the form { name = ""; file = ""; modules = []; }
  handleTestFile =
    file: namespace:
    let
      fnOrAttrs = import file;
      cases =
        if builtins.isFunction fnOrAttrs then
          # Call the function
          fnOrAttrs { inherit pkgs lib helpers; }
        else
          fnOrAttrs;
    in
    {
      inherit file;
      name = lib.strings.concatStringsSep "-" namespace;
      modules = lib.mapAttrsToList (name: module: { inherit name module; }) cases;
    };

  # Recurse into all directories, extracting files as we find them.
  # This returns a list of { name; file; modules;  } attrsets.
  fetchTests =
    path: namespace:
    let
      # Handle an entry from readDir
      # - If it is a regular nix file, import its content
      # - If it is a directory, continue recursively
      handleEntry =
        name: type:
        let
          file = "${path}/${name}";
        in
        if type == "regular" then
          lib.optional (lib.hasSuffix ".nix" name) (
            handleTestFile file (namespace ++ [ (lib.removeSuffix ".nix" name) ])
          )
        else
          fetchTests file (namespace ++ [ name ]);
    in
    lib.pipe path [
      builtins.readDir
      (lib.filterAttrs (n: v: v != "symlink"))
      (lib.mapAttrsToList handleEntry)
      builtins.concatLists
    ];
in
# A list of the form [ { name = "..."; modules = [ /* test case modules */ ]; } ]
fetchTests root [ ]
