{
  empty = {
    # TODO: added 2025-03-24
    # pkgs.texpresso is broken
    # https://github.com/NixOS/nixpkgs/issues/392649
    plugins.texpresso.enable = false;
  };
}
