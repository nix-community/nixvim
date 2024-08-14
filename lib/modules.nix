{
  lib,
  self,
}:
rec {
  # Minimal specialArgs required to evaluate nixvim modules
  specialArgs = specialArgsWith { };

  # Build specialArgs for evaluating nixvim modules
  specialArgsWith =
    extraSpecialArgs:
    {
      inherit lib;
      # TODO: deprecate `helpers`
      helpers = self;
    }
    // extraSpecialArgs;

  # Evaluate nixvim modules, checking warnings and assertions
  evalNixvim =
    {
      modules ? [ ],
      extraSpecialArgs ? { },
      check ? null, # TODO: Remove stub
    }@args:
    # TODO: `check` argument removed 2024-09-24
    # NOTE: this argument was always marked as experimental
    assert lib.assertMsg (!args ? "check")
      "`evalNixvim`: passing `check` is no longer supported. Checks are now done when evaluating `config.build.package` and can be avoided by using `config.build.packageUnchecked` instead.";
    lib.evalModules {
      modules = [ ../modules/top-level ] ++ modules;
      specialArgs = specialArgsWith extraSpecialArgs;
    };

  # TODO: Removed 2024-09-24
  getAssertionMessages = throw "`modules.getAssertionMessages` has been removed.";
}
