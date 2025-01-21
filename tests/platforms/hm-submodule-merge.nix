{
  self,
  pkgs,
}:
# This test covers a user-reported regression where nixvim's submodule-option (programs.nixvim)
# cannot correctly merge options declared from the parent scope.
#
# Strangely, this only happens when the option is declared in a nested import.
#
# To be clear, this is an upstream module system bug, this test validates our workaround.
let
  inherit (self.inputs.home-manager.lib)
    homeManagerConfiguration
    ;

  # This test module declares a nixvim option from a home-manager module
  # The module system will attempt an option-type merge on the `programs.nixvim` option,
  # extending the submodule-type with an extra module declaring the nixvim option.
  test-module =
    { lib, ... }:
    {
      options.programs.nixvim = {
        foo = lib.mkEnableOption "foo";
      };
    };

  configuration = homeManagerConfiguration {
    inherit pkgs;

    modules = [
      (
        { lib, ... }:
        {
          # NOTE: the issue is only reproduced with nested imports.
          imports = [ { imports = [ test-module ]; } ];

          home.username = "nixvim";
          home.homeDirectory = "/invalid/dir";
          home.stateVersion = "24.11";
          programs.home-manager.enable = true;

          programs.nixvim.enable = true;

          # Validate the test is effective
          assertions = [
            {
              assertion = !lib ? nixvim;
              message = "expected a non-nixvim lib";
            }
          ];
        }
      )
      self.homeManagerModules.nixvim
    ];
  };
in
configuration.activationPackage
