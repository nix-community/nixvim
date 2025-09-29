{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];
  perSystem =
    { config, ... }:
    {
      overlayAttrs = {
        nixvim = {
          inherit (config.legacyPackages) makeNixvim makeNixvimWithModule;
        };
      };
    };
}
