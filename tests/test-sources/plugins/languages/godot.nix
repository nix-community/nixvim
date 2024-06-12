{ pkgs, ... }:
{
  empty = {
    # Godot is only available on Linux
    plugins.godot.enable = pkgs.stdenv.isLinux;
  };

  defaults = {
    plugins.godot = {
      # Godot is only available on Linux
      enable = pkgs.stdenv.isLinux;

      settings = {
        executable = "godot";
      };
    };
  };
}
