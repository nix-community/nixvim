{ lib, pkgs, ... }:
# TODO: Added 2025-05-28
# `opencsg` fails to build on darwin
# https://github.com/NixOS/nixpkgs/issues/411700
lib.optionalAttrs (!pkgs.stdenv.hostPlatform.isDarwin) {
  empty = {
    plugins.openscad.enable = true;
  };

  defaults = {
    plugins.openscad = {
      enable = true;

      settings = {
        fuzzy_finder = "skim";
        cheatsheet_window_blend = 15;
        load_snippets = false;
        auto_open = false;
        default_mappings = true;
        cheatsheet_toggle_key = "<Enter>";
        help_trig_key = "<A-h>";
        help_manual_trig_key = "<A-m>";
        exec_openscad_trig_key = "<A-o>";
        top_toggle = "<A-c>";
      };
    };
  };

  example = {
    plugins.openscad = {
      enable = true;

      settings = {
        load_snippets = true;
        fuzzy_finder = "fzf";
        cheatsheet_window_blend = 15;
        auto_open = true;
      };
    };
  };
}
