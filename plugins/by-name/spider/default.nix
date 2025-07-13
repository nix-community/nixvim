{
  lib,
  ...
}:
let
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "spider";
  packPathName = "nvim-spider";
  package = "nvim-spider";
  maintainers = [ lib.maintainers.saygo-png ];
  description = "Use the w, e, b motions like a spider. Move by subwords and skip insignificant punctuation.";

  extraOptions = {
    keymaps = {
      silent = lib.mkOption {
        type = lib.types.bool;
        description = "Whether spider keymaps should be silent.";
        default = false;
      };

      motions = lib.mkOption {
        type = types.attrsOf types.str;
        description = ''
          Mappings for spider motions.
          The keys are the motion and the values are the keyboard shortcuts.
          The shortcut might not necessarily be the same as the motion name.
        '';
        default = { };
        example = {
          w = "w";
          e = "e";
          b = "b";
          ge = "ge";
        };
      };
    };
  };

  # TODO: introduced 2025-07-13: remove after 25.11
  inherit (import ./deprecations.nix lib) deprecateExtraOptions imports;

  extraConfig = cfg: {
    extraLuaPackages = luaPkgs: [ luaPkgs.luautf8 ];

    keymaps = lib.mapAttrsToList (motion: key: {
      mode = [
        "n"
        "o"
        "x"
      ];
      inherit key;
      action.__raw = "function() require('spider').motion('${motion}') end";
      options = {
        inherit (cfg.keymaps) silent;
        desc = "Spider-${motion}";
      };
    }) cfg.keymaps.motions;
  };
}
