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
    config = {
      _module.args = extraSpecialArgs;
    };
  };

  eval = lib.evalModules {
    modules = [module wrap] ++ shared.topLevelModules;
  };

  handleAssertions = config: let
    failedAssertions = map (x: x.message) (lib.filter (x: !x.assertion) config.assertions);
  in
    if failedAssertions != []
    then throw "\nFailed assertions:\n${builtins.concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
    else lib.showWarnings config.warnings config;

  config = handleAssertions eval.config;
in
  config.finalPackage.overrideAttrs (oa: {
    preInstall =
      if config.enableMan
      then ''
        mkdir -p $out/share/man/man5
        cp ${self.packages.${pkgs.system}.man-docs}/share/man/man5/nixvim.5 $out/share/man/man5
      ''
      else ''
      '';
  })
