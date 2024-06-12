{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];
  perSystem =
    {
      config,
      pkgs,
      final,
      ...
    }:
    {
      overlayAttrs = {
        nixvim = {
          inherit (config.legacyPackages) makeNixvim makeNixvimWithModule;
        };
      };
    };
}
