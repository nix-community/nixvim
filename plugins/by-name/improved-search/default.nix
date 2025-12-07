{ lib, ... }:
# This plugin is only configured through keymaps, so we use `mkVimPlugin` without the
# `globalPrefix` argument to avoid the creation of the `settings` option.
let
  inherit (lib) mkOption;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "improved-search";
  package = "improved-search-nvim";
  description = "It's a Neovim plugin that improves the search experience.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraOptions = {
    keymaps = mkOption {
      description = ''
        Keymap definitions for search functions

        See [here](https://github.com/backdround/improved-search.nvim?tab=readme-ov-file#functions-and-operators) for the list of available callbacks.
      '';
      type =
        with lib.types;
        listOf (submodule {
          options = {
            key = mkOption {
              type = str;
              description = "The key to map.";
              example = "!";
            };

            mode = lib.nixvim.keymaps.mkModeOption "";

            action = mkOption {
              type =
                with lib.types;
                maybeRaw (
                  # https://github.com/backdround/improved-search.nvim?tab=readme-ov-file#functions-and-operators
                  enum [
                    "stable_next"
                    "stable_previous"
                    "current_word"
                    "current_word_strict"
                    "in_place"
                    "in_place_strict"
                    "forward"
                    "forward_strict"
                    "backward"
                    "backward_strict"
                  ]
                );
              description = ''
                The action to execute.

                See [here](https://github.com/backdround/improved-search.nvim?tab=readme-ov-file#functions-and-operators) for the list of available callbacks.
              '';
              example = "in_place";
            };

            options = lib.nixvim.keymaps.mapConfigOptions;
          };
        });
      default = [ ];
      example = [
        {
          mode = [
            "n"
            "x"
            "o"
          ];
          key = "n";
          action = "stable_next";
        }
        {
          mode = [
            "n"
            "x"
            "o"
          ];
          key = "N";
          action = "stable_previous";
        }
        {
          mode = "n";
          key = "!";
          action = "current_word";
          options.desc = "Search current word without moving";
        }
        {
          mode = "x";
          key = "!";
          action = "in_place";
        }
        {
          mode = "x";
          key = "*";
          action = "forward";
        }
        {
          mode = "x";
          key = "#";
          action = "backward";
        }
        {
          mode = "n";
          key = "|";
          action = "in_place";
        }
      ];
    };
  };

  extraConfig = cfg: {
    keymaps = map (keymap: {
      inherit (keymap) key options mode;
      action =
        if
          lib.isString keymap.action
        # One of the plugin builtin functions
        then
          lib.nixvim.mkRaw "require('improved-search').${keymap.action}"
        # If the user specifies a raw action directly
        else
          keymap.action;
    }) cfg.keymaps;
  };
}
