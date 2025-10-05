{
  empty = {
    # TODO: 2025-10-03
    # Transient dependency `vmr` has a build failure
    # https://github.com/NixOS/nixpkgs/issues/431811
    dependencies.roslyn_ls.enable = false;
    plugins.roslyn.enable = true;
  };

  defaults = {
    # TODO: 2025-10-03
    # Transient dependency `vmr` has a build failure
    # https://github.com/NixOS/nixpkgs/issues/431811
    dependencies.roslyn_ls.enable = false;
    plugins.roslyn = {
      enable = true;
      settings = {
        filewatching = "auto";
        choose_target = null;
        ignore_target = null;
        broad_search = false;
        lock_target = false;
        silent = false;
      };
    };
  };
}
