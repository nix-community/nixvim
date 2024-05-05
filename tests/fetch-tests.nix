{
  root,
  lib,
  pkgs,
  helpers,
}:
let
  # Handle an entry from readDir and either extract the configuration if its a regular file,
  # or continue to recurse if it's a directory. While recursing maintain a list of the traversed
  # directories
  handleEntry =
    relativePath: namespace: name: type:
    let
      file = "${root}/${relativePath}/${name}";
    in
    if type == "regular" then
      [
        {
          namespace = namespace ++ [ (lib.strings.removeSuffix ".nix" name) ];
          cases = import file;
        }
      ]
    else
      parseDirectories file (namespace ++ [ name ]);

  # Recurse into all directories, extracting files as we find them. This returns a deeply nested
  # list, where each non list element is a set of test cases.
  parseDirectories =
    path: namespace:
    let
      relativePath = lib.removePrefix "${root}" "${path}";

      children = builtins.readDir path;
      childrenFiltered = lib.attrsets.filterAttrs (n: v: v != "symlink") children;

      childrenRecursed = lib.attrsets.mapAttrsToList (handleEntry relativePath namespace) childrenFiltered;
    in
    childrenRecursed;

  # Remove the nesting
  testsList = lib.lists.flatten (parseDirectories root [ ]);

  testsListEvaluated = builtins.map (
    { cases, namespace }@args:
    if builtins.isAttrs cases then
      args
    else
      {
        # cases is a function
        cases = cases {
          inherit pkgs helpers;
          efmls-options = import ../plugins/lsp/language-servers/efmls-configs.nix {
            inherit pkgs lib helpers;
            config = { };
          };
          nonels-sources-options = import ../plugins/none-ls/servers.nix {
            inherit pkgs lib helpers;
            config = { };
          };
          cmp-sources = import ../plugins/completion/cmp/sources.nix;
        };
        inherit namespace;
      }
  ) testsList;

  # Take a list of test cases (i.e the content of a file) and prepare a test case that can be
  # handled by mkTestDerivation
  handleTestFile =
    { namespace, cases }:
    lib.attrsets.mapAttrs' (case: config: {
      name = lib.strings.concatStringsSep "-" (namespace ++ [ case ]);
      value = config;
    }) cases;

  # Helper function that calls `//` for each attrset of a list
  concatMany = lib.lists.foldr lib.mergeAttrs { };
in
# An attrset of 'test-name' -> 'test-config'
concatMany (builtins.map handleTestFile testsListEvaluated)
