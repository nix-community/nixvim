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
  # Warnings and assertions are checked when you evaluate the `config` attr
  evalNixvim =
    {
      modules ? [ ],
      extraSpecialArgs ? { },
    }:
    let
      result = lib.evalModules {
        modules = [ ../modules/top-level ] ++ modules;
        specialArgs = specialArgsWith extraSpecialArgs;
      };

      failedAssertions = getAssertionMessages result.config.assertions;

      checked =
        if failedAssertions != [ ] then
          throw "\nFailed assertions:\n${lib.concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
        else
          lib.showWarnings result.config.warnings result;
    in
    checked;

  # Return the messages for all assertions that failed
  getAssertionMessages =
    assertions:
    lib.pipe assertions [
      (lib.filter (x: !x.assertion))
      (lib.map (x: x.message))
    ];
}
