{
  lib,
  config,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "diffview";
  package = "diffview-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    keymaps =
      let
        keymapEntryType = types.submodule {
          options = {
            mode = lib.mkOption {
              type = types.str;
              description = "Mode to bind keybinding to";
              example = "n";
            };
            key = lib.mkOption {
              type = types.str;
              description = "Key to bind keybinding to";
              example = "<tab>";
            };
            action = lib.mkOption {
              type = with types; maybeRaw str;
              description = "Action for keybinding";
              example = lib.nixvim.nestedLiteralLua "require('diffview.actions').select_next_entry";
            };
            description = defaultNullOpts.mkStr null "Description for keybinding";
          };
        };

        keymapContexts = {
          disable_defaults = {
            type = "bool";
            description = "Disable the default keymaps";
          };
          view = "The `view` bindings are active in the diff buffers, only when the current tabpage is a Diffview";
          diff1 = "Mappings in single window diff layouts";
          diff2 = "Mappings in 2-way diff layouts";
          diff3 = "Mappings in 3-way diff layouts";
          diff4 = "Mappings in 4-way diff layouts";
          file_panel = "Mappings in file panel";
          file_history_panel = "Mappings in file history panel";
          option_panel = "Mappings in options panel";
          help_panel = "Mappings in help panel";
        };

        convertToKeybinding = attr: [
          attr.mode
          attr.key
          attr.action
          { "desc" = attr.description; }
        ];
      in
      lib.mkOption {
        type = types.submodule {
          options = lib.mapAttrs (
            name: desc:
            if name == "disable_defaults" then
              defaultNullOpts.mkBool false desc.description
            else
              lib.mkOption {
                type = types.listOf keymapEntryType;
                default = [ ];
                description = "List of keybindings. ${desc}";
                example = [
                  {
                    mode = "n";
                    key = "<tab>";
                    action = lib.nixvim.nestedLiteralLua "require('diffview.actions').select_next_entry";
                    description = "Open the diff for the next file";
                  }
                ];
              }
          ) keymapContexts;
        };
        default = { };
        description = ''
          Keymap configuration for different diffview contexts.
          Each keymap list will be automatically converted to the format expected by diffview.nvim.
        '';
        apply =
          keymapCfg:
          {
            inherit (keymapCfg) disable_defaults;
          }
          // lib.mapAttrs (_: keyList: map convertToKeybinding keyList) (
            lib.removeAttrs keymapCfg [ "disable_defaults" ]
          );
      };
  };

  extraConfig =
    cfg:
    lib.mkIf cfg.enable {
      # TODO: added 2024-09-20 remove after 24.11
      plugins.web-devicons = lib.mkIf (
        !(
          (
            config.plugins.mini.enable
            && config.plugins.mini.modules ? icons
            && config.plugins.mini.mockDevIcons
          )
          || (config.plugins.mini-icons.enable && config.plugins.mini-icons.mockDevIcons)
        )
      ) { enable = lib.mkOverride 1490 true; };
    };

  # TODO: Deprecated 2025-10-04
  inherit (import ./deprecations.nix { inherit lib; })
    optionsRenamedToSettings
    deprecateExtraOptions
    ;
}
