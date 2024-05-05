{
  config,
  lib,
  withSystem,
  ...
}: {
  flake.lib = lib.genAttrs config.systems (
    lib.flip withSystem (
      {
        pkgs,
        config,
        ...
      }:
        import ../lib {
          inherit pkgs lib;
          inherit (config.legacyPackages) makeNixvim makeNixvimWithModule;
        }
    )
  );
}
