{
  lib,
  inputs,
  config,
  partitionStack,
  ...
}:
{
  imports = [
    ./flake-modules
    ./ci.nix
    ./inputs.nix
    ./lib.nix
    ./nixvim-configurations.nix
    ./overlays.nix
    ./packages.nix
    ./templates.nix
    ./wrappers.nix
    inputs.flake-parts.flakeModules.partitions
  ];

  # Define flake partitions
  # Each has a `module`, assigned to the partition's submodule,
  # and an `extraInputsFlake`, used for its inputs.
  # See https://flake.parts/options/flake-parts-partitions.html
  partitions = {
    dev = {
      module = ./dev;
      extraInputsFlake = ./dev;
    };
  };

  # Specify which outputs are defined by which partitions
  partitionedAttrs = {
    ci = "dev";
    checks = "dev";
    devShells = "dev";
    formatter = "dev";
  };

  # For any output attrs normally defined by the root flake configuration,
  # any exceptions must be manually propagated from the `dev` partition.
  #
  # NOTE: Attrs should be explicitly propagated at the deepest level.
  # Otherwise the partition won't be lazy, making it pointless.
  # E.g. propagate `packages.${system}.foo` instead of `packages.${system}`
  # See: https://github.com/hercules-ci/flake-parts/issues/258
  perSystem =
    { system, ... }:
    {
      packages = lib.optionalAttrs (partitionStack == [ ]) {
        # Propagate `packages` from the `dev` partition:
        inherit (config.partitions.dev.module.flake.packages.${system})
          generate-all-maintainers
          ;
      };
    };
}
