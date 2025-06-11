# CI scripts

This directory contains CI-related scripts that are not part of the actual flake.
Unless developing or testing changes, you shouldn't need to run them manually.

## Developing

Because these scripts aren't packaged in the flake, you should use `nix-build` and `nix-shell` instead of `nix build`, `nix run`, and `nix develop`, etc.

For example, `nix-build -A generate` will build `./generate.nix` into `./result/bin/generate`.

A `shell.nix` is available that will place `generate` on your PATH.

You could use this directory's shell/packages from another working directory by supplying `nix-build` or `nix-shell` with a path.
E.g. `nix-shell ./ci`.

## Explanation

These packages are not in the flake outputs for three main reasons:
- Packages built using the flake must follow the flake's `nixConfig`
- Packages included in the flake's output are checked by `nix flake check`
- Some of the packages should have no dependency on the flake at all,
  allowing this directory to be [sparse checked out][sparse-checkout] by a workflow

Being unable to bypass `nixConfig` is an issue because we want to disable [IFD] for the flake, but not for these scripts.

If something changes upstream that causes the builds to fail, we don't want this to block us updating `flake.lock`.
We'd still be made aware of any issues by the `update` CI workflow failing.

[sparse-checkout]: https://github.com/actions/checkout#scenarios
[IFD]: https://nixos.org/manual/nix/stable/language/import-from-derivation
