{
  self,
  inputs,
  ...
}:
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
  flake.overlays = {
    # Export our lib extension overlay
    # Note: this is an overlay for nixpkg's lib, not for nixpkgs itself
    # You can pass the overlay to `lib.extend`
    lib = import ../lib/overlay.nix { };
  };
}
