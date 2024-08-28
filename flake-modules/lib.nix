{
  self,
  config,
  lib,
  getSystem,
  ...
}:
{
  perSystem =
    { self', pkgs, ... }:
    {
      # `helpers` is used throughout the flake modules
      _module.args = {
        inherit (self'.lib) helpers;
      };

      legacyPackages = {
        # Export nixvim's lib in legacyPackages
        lib = import ../lib {
          inherit pkgs lib;
          flake = self;
        };

        # Historically, we exposed these at the top-level of legacyPackages
        # TODO: Consider renaming the new location, and keeping the old name here?
        inherit (self'.legacyPackages.lib) makeNixvimWithModule makeNixvim;
      };
    };

  # Also expose `legacyPackages.<system>.lib` as `lib.<system>`
  flake.lib = lib.genAttrs config.systems (system: (getSystem system).legacyPackages.lib);
}
