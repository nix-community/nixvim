default_pkgs: modules: {
  pkgs ? default_pkgs,
  module,
}: let
  inherit (pkgs) lib;

  wrap = {wrapRc = true;};

  eval = lib.evalModules {
    modules = (modules pkgs) ++ [module wrap];
  };

  handleAssertions = config: let
    failedAssertions = map (x: x.message) (lib.filter (x: !x.assertion) config.assertions);
  in
    if failedAssertions != []
    then throw "\nFailed assertions:\n${builtins.concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
    else lib.showWarnings config.warnings config;

  config = handleAssertions eval.config;
in
  config.finalPackage
