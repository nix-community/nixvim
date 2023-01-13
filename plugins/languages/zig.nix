{ config, lib, pkgs, ... }@attrs:
let
  helpers = import ../helpers.nix { inherit config lib; };
in with helpers; with lib;
mkPlugin attrs {
  name = "zig";
  description = "Enable zig";
  extraPlugins = [ pkgs.vimPlugins.zig-vim ];

  # Possibly add option to disable Treesitter highlighting if this is installed
  options = {
    formatOnSave = mkDefaultOpt {
      type = types.bool;
      global = "zig_fmt_autosave";
      description = "Run zig fmt on save";
    };
  };
}
