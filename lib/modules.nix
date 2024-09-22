{
  lib,
  self,
}:
rec {
  # Build specialArgs for evaluating nixvim modules
  specialArgsWith =
    # TODO: switch defaultPkgs -> pkgsPath (i.e. pkgs.path or inputs.nixvim)
    # FIXME: Ideally, we should not require callers to pass in _anything_ specific
    { defaultPkgs, ... }@extraSpecialArgs:
    {
      inherit lib defaultPkgs;
      # TODO: deprecate `helpers`
      helpers = self;
      pkgsPath = defaultPkgs.path;
    }
    // extraSpecialArgs;

  # Evaluate nixvim modules, checking warnings and assertions
  evalNixvim =
    {
      modules ? [ ],
      extraSpecialArgs ? { },
      # Set to false to disable warnings and assertions
      # Intended to aid accessing config.test.derivation
      # WARNING: This argument may be removed without notice:
      check ? true,
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
    if check then checked else result;

  # Return the messages for all assertions that failed
  getAssertionMessages =
    assertions:
    lib.pipe assertions [
      (lib.filter (x: !x.assertion))
      (lib.map (x: x.message))
    ];
}
