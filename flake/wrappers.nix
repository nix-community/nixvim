{
  self,
  lib,
  ...
}:
let
  # Added 2025-05-25; warning shown since 2025-08-01 (25.11)
  # NOTE: top-level binding of a fully resolved value, to avoid printing multiple times
  homeManagerModulesWarning = lib.warn "nixvim: flake output `homeManagerModules` has been renamed to `homeModules`." null;

  # A base configuration used to evaluate the wrapper modules.
  #
  # While we don't define a `pkgs` or `hostPlatform` here, which would normally
  # lead to eval errors, disabling option-declaration checking gives us enough
  # laziness to evaluate the options we need.
  #
  # The `_module.check` module has a key, so we can disable it later in the
  # platform wrapper modules.
  configuration = self.lib.evalNixvim {
    modules = [
      {
        key = "<internal:nixvim-nocheck-base-eval>";
        config._module.check = false;
      }
    ];
  };
in
{
  perSystem =
    { config, system, ... }:
    let
      inherit (config.legacyPackages) makeNixvimWithModule;
    in
    {
      legacyPackages = {
        makeNixvimWithModule = import ../wrappers/standalone.nix {
          inherit lib self;
          defaultSystem = system;
        };
        makeNixvim = module: makeNixvimWithModule { inherit module; };
      };
    };

  flake = {
    nixosModules = {
      nixvim = configuration.config.build.nixosModule;
      default = self.nixosModules.nixvim;
    };
    # Alias for backward compatibility
    homeManagerModules = lib.mapAttrs (_: lib.seq homeManagerModulesWarning) self.homeModules;
    homeModules = {
      nixvim = configuration.config.build.homeModule;
      default = self.homeModules.nixvim;
    };
    nixDarwinModules = {
      nixvim = configuration.config.build.nixDarwinModule;
      default = self.nixDarwinModules.nixvim;
    };
  };
}
