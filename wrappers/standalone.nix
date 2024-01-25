default_pkgs: {
  modules,
  self,
}: {
  pkgs ? default_pkgs,
  extraSpecialArgs ? {},
  module,
}: let
  inherit (pkgs) lib;

  wrap = {wrapRc = true;};

  shared = import ./_shared.nix modules {
    inherit pkgs lib;
    config = {};
  };

  eval = lib.evalModules {
    modules = [module wrap] ++ shared.topLevelModules;
    specialArgs = extraSpecialArgs;
  };

  handleAssertions = config: let
    failedAssertions = map (x: x.message) (lib.filter (x: !x.assertion) config.assertions);
  in
    if failedAssertions != []
    then throw "\nFailed assertions:\n${builtins.concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
    else lib.showWarnings config.warnings config;

  config = handleAssertions eval.config;
in
  pkgs.symlinkJoin {
    name = "nixvim";
    paths =
      [
        config.finalPackage
        config.printInitPackage
      ]
      ++ pkgs.lib.optional config.enableMan self.packages.${pkgs.system}.man-docs;
    meta.mainProgram = "nvim";
  }
