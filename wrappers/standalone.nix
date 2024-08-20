default_pkgs: self:
{
  pkgs ? default_pkgs,
  lib ? pkgs.lib,
  extraSpecialArgs ? { },
  module,
}:
let
  helpers = import ../lib/helpers.nix { inherit pkgs lib; };

  inherit (helpers.modules) specialArgsWith;

  handleAssertions =
    config:
    let
      failedAssertions = map (x: x.message) (lib.filter (x: !x.assertion) config.assertions);
    in
    if failedAssertions != [ ] then
      throw "\nFailed assertions:\n${builtins.concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
    else
      lib.showWarnings config.warnings config;

  mkNvim =
    mod:
    let
      evaledModule = lib.evalModules {
        modules = [
          mod
          ./modules/standalone.nix
          ../modules/top-level
        ];
        specialArgs = specialArgsWith extraSpecialArgs;
      };
      config = handleAssertions evaledModule.config;
    in
    (pkgs.symlinkJoin {
      name = "nixvim";
      paths = [
        config.finalPackage
        config.printInitPackage
      ] ++ pkgs.lib.optional config.enableMan self.packages.${pkgs.stdenv.hostPlatform.system}.man-docs;
      meta.mainProgram = "nvim";
    })
    // rec {
      inherit config;
      inherit (evaledModule) options;
      extend =
        extension:
        mkNvim {
          imports = [
            mod
            extension
          ];
        };
      nixvimExtend = lib.warn "<nixvim>.nixvimExtend has been renamed to <nixvim>.extend" extend;
    };
in
mkNvim module
