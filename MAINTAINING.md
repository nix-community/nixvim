# Maintaining Nixvim

This file is intended as a reference for Nixvim's core maintainers, although it may be interesting for anyone curious how we do certain things.

## Deprecation

We aim to guarantee a seamless experience for stable channel users by providing rename aliases, removal notices, and other warnings and assertions.

Deprecations should include a comment in the format of:
```nix
# TODO: Added YYYY-MM-DD, remove after <n+2>
```

where:

- `n` is the current release; 26.05 at the time of writing
- `n+1` is the next release; 26.05 at the time of writing
- `n+2` is the release following `n+1`; 26.11 at the time of writing

If a warning is created on release `n`, then:

- We **should not** remove it before `n+1` is released unless there is a bug or it is plain wrong
- We **may** remove it after `n+1` is released, but only if it causes undue friction
- We **should** remove it once `n+2` is released, as routine cleanup

## Releasing

Nixvim releases stable versions in sync with nixpkgs. A _`YY.05`_ version is released in May and a _`YY.11`_ version is released in November.

A new release branch can be created at any point during the Nixpkgs branch-off period.
We do not need to wait for the release to come out of _“beta”_ before creating a branch, however we _should_ wait before updating links and references on the `main` branch.
See [Creating the release branch](#creating-the-release-branch) below.

Once a stable branch is created, its flake inputs should be updated to point to the corresponding stable versions.
See [Pinning the release branch's inputs](#pinning-the-release-branch-inputs).

Once a stable version is considered "out of beta", references to Nixvim's stable branch should be updated on the `main` branch to reference the new version.

### version-info

The `update` workflow will automatically add info about stable branches to `version-info.toml`.
This is used by CI workflows like `update-other` and `website` to automatically list supported stable versions.

This should usually be handled automatically, however errors may show up if a version is added to `version-info.toml` before the corresponding Nixvim branch exists.

### Creating the release branch

Currently, anyone with write access can create new branches.
A branch can be created using GitHub's [web UI](https://github.com/nix-community/nixvim/branches) or by pushing to `upstream` using the `git` CLI.

The branch should be named `nixos-YY.MM` (replacing `YY.MM` with the actual release version), corresponding with the targeted Nixpkgs release.

Ideally, the new branch should be created before `main` is bumped onto the next unstable release.
Otherwise, the new branch can be created at an earlier commit in `main`'s history, from before the bump.

> [!IMPORTANT]
> Currently, GitHub Rulesets enabling Merge Queue cannot target a branch pattern.
> Therefore, we must manually add the new `nixos-YY.MM` branch to our [Merge Queues ruleset](https://github.com/nix-community/nixvim/settings/rules/17034101).

If the branch naming scheme is ever changed, we must update any GitHub Rulesets targeting the `nixos-*` branch pattern.

### Pinning the release branch inputs

Once a stable branch is created, its flake inputs should be updated to point to the corresponding stable versions.
This is typically done in a PR targeting the new release branch, after the branch has been created.
If release-specific URLs do not exist immediately, they can be left untouched.
Follow-up PRs should update to pinned-URLs as they become available.

## Archiving

Once a release is no longer maintained, it can be added to the [Archived branches ruleset](https://github.com/nix-community/nixvim/settings/rules/17034875) and removed from the [Merge Queues ruleset](https://github.com/nix-community/nixvim/settings/rules/17034101).
This will block pushing to those branches, even via PRs.

We have not discussed whether an archival notice should be added to unmaintained branch READMEs,
or whether evaluating unmaintained branches should print a warning.
