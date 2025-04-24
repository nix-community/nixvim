{
  lib,
  pkgs,
  ...
}:
let
  # Godot is only available on Linux
  enable = lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.godot_4;
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
