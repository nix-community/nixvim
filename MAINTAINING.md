# Maintaining Nixvim

This file is intended as a reference for Nixvim's core maintainers, although it may be interesting for anyone curious how we do certain things.

## Deprecation

The deprecation policy discussion is happening in [#3181](https://github.com/nix-community/nixvim/issues/3181).

## Releasing

Nixvim releases stable versions in sync with nixpkgs. A YY.05 version is released in May and a YY.11 version is released in November.

We do not need to wait for the release to be "stable" before creating a branch, however we _should_ wait before updating links and references on the `main` branch.

Creating a stable branch may require temporarily disabling branch protection. This can only be done by an "admin" or "owner".

Once a stable branch is created, its flake inputs should be updated to point to the corresponding stable versions.
The branch can be created before these exist, in which case they should be updated when the corresponding stable inputs become available.

Once a stable branch is created, it should be added to the `update-other` workflow on the `main` branch.

Once a stable branch is considered "public", it should be added to the `build_documentation` workflow on the `main` branch.
This can be done while the version is still "beta".

Once a stable version is considered "out of beta", references to Nixvim's stable branch should be updated on the `main` branch to reference the new version.

### Deprecating old releases

Once a stable branch is deprecated, it should be removed from the `update-other` workflow on the `main` branch.

It should also be removed from the `build_documentation` workflow on the `main` branch.
