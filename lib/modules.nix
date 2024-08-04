{
  pkgs,
  lib,
  helpers,
}:
rec {
  # Minimal specialArgs required to evaluate nixvim modules
  specialArgs = specialArgsWith { };

  # Build specialArgs for evaluating nixvim modules
  specialArgsWith =
    extraSpecialArgs:
    {
      # TODO: deprecate `helpers`
      inherit lib helpers;
      defaultPkgs = pkgs;
    }
    // extraSpecialArgs;

  # Evaluate nixvim modules
  evalNixvim =
    {
      modules ? [ ],
      extraSpecialArgs ? { },
      isTopLevel ? true,
      checkWarnings ? true,
      checkAssertions ? true,
    }:
    let
      result = lib.evalModules {
        modules = [ (if isTopLevel then ../modules/top-level else ../modules) ] ++ modules;
        specialArgs = specialArgsWith extraSpecialArgs;
      };

      failedAssertions = getAssertionMessages result.config.assertions;

      checkWarningsFn = if checkWarnings then lib.showWarnings result.config.warnings else lib.id;

      checkAssertionsFn =
        if checkAssertions && failedAssertions != [ ] then
          _: throw "\nFailed assertions:\n${lib.concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
        else
          lib.id;
    in
    checkWarningsFn (checkAssertionsFn result);

  # Return the messages for all assertions that failed
  getAssertionMessages =
    assertions:
    lib.pipe assertions [
      (lib.filter (x: !x.assertion))
      (lib.map (x: x.message))
    ];
}
