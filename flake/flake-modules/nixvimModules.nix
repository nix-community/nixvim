{
  lib,
  flake-parts-lib,
  moduleLocation,
  ...
}:
{
  options = {
    flake = flake-parts-lib.mkSubmoduleOptions {
      nixvimModules = lib.mkOption {
        type = with lib.types; lazyAttrsOf deferredModule;
        default = { };
        apply = lib.mapAttrs (
          name: module: {
            _file = "${toString moduleLocation}#nixvimModules.${name}";
            imports = [ module ];
          }
        );
        description = ''
          Nixvim modules.

          You may use this for reusable pieces of configuration, utility modules, etc.
        '';
      };
    };
  };
}
