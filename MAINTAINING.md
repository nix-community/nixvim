# Maintaining Nixvim

This file is intended as a reference for Nixvim's core maintainers, although it may be interesting for anyone curious how we do certain things.

## Deprecation

We aim to guarantee a seamless experience for stable channel users by providing rename aliases, removal notices, and other warnings and assertions.

Deprecations should include a comment in the format of:
```nix
# TODO: Added YYYY-MM-DD, remove after <n+2>
```

where:

- `n` is the current release; 25.05 at the time of writing
- `n+1` is the next release; 25.11 at the time of writing
- `n+2` is the release following `n+1`; 26.05 at the time of writing

If a warning is created on release `n`, then:

- We **should not** remove it before `n+1` is released unless there is a bug or it is plain wrong
- We **may** remove it after `n+1` is released, but only if it causes undue friction
- We **should** remove it once `n+2` is released, as routine cleanup

## Releasing

Nixvim releases stable versions in sync with nixpkgs. A _`YY.05`_ version is released in May and a _`YY.11`_ version is released in November.

We do not need to wait for the release to come out of _“beta”_ before creating a branch, however we _should_ wait before updating links and references on the `main` branch.

Creating a stable branch may require temporarily disabling branch protection. This can only be done by an "admin" or "owner".

Once a stable branch is created, its flake inputs should be updated to point to the corresponding stable versions.
The branch can be created before these exist, in which case they should be updated when the corresponding stable inputs become available.

Once a stable version is considered "out of beta", references to Nixvim's stable branch should be updated on the `main` branch to reference the new version.

### version-info

The `update` workflow will automatically add info about stable branches to `version-info.toml`.
This is used by CI workflows like `update-other` and `website` to automatically list supported stable versions.

This should usually be handled automatically, however errors may show up if a version is added to `version-info.toml` before the corresponding Nixvim branch exists.
