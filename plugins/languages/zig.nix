{
  lib,
  pkgs,
  ...
} @ attrs: let
  helpers = import ../helpers.nix {inherit lib;};
in
  with helpers;
  with lib;
    mkPlugin attrs {
      name = "zig";
      description = "Enable zig";
      package = pkgs.vimPlugins.zig-vim;
      globalPrefix = "zig_";

      # Possibly add option to disable Treesitter highlighting if this is installed
      options = {
        formatOnSave = mkDefaultOpt {
          type = types.bool;
          global = "fmt_autosave";
          description = "Run zig fmt on save";
        };
      };
    }
