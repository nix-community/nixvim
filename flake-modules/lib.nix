{
  config,
  lib,
  withSystem,
  ...
}:
{
  flake.lib = lib.genAttrs config.systems (
    lib.flip withSystem ({ pkgs, ... }: import ../lib { inherit pkgs lib; })
  );
}
