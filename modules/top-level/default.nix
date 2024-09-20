# Alternative to `/modules` that also includes modules that should only exist at the "top-level".
# Therefore, `/modules` should be used instead for submodules nested within a nixvim config.
#
# When using this, you likely also want a "wrapper" module for any platform-specific options.
# See `/wrappers/modules` for examples.
{
  imports = [
    ../.
    ./files
    ./nixpkgs.nix
    ./output.nix
    ./readonly-renames.nix
    ./test.nix
  ];

  config = {
    isTopLevel = true;
  };
}
