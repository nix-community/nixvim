{
  lib,
  pkgs,
  ...
}:
let
  enable =
    # TODO: 2025-04-20: build failure of godot_4
    # https://github.com/NixOS/nixpkgs/issues/399818
    # https://github.com/NixOS/nixpkgs/pull/400347
    false
    # Godot is only available on Linux
    && lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.godot_4;
in
lib.optionalAttrs enable {
  empty = {
    plugins.godot.enable = true;
  };

  defaults = {
    plugins.godot = {
      enable = true;

      settings = {
        executable = "godot";
      };
    };
  };
}
