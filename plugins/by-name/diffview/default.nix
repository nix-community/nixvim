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
        keymapList =
          desc:
          lib.mkOption {
            type = types.listOf (
              types.submodule {
                options = {
                  mode = lib.mkOption {
                    type = types.str;
                    description = "mode to bind keybinding to";
                    example = "n";
                  };
                  key = lib.mkOption {
                    type = types.str;
                    description = "key to bind keybinding to";
                    example = "<tab>";
                  };
                  action = lib.mkOption {
                    type = types.str;
                    description = "action for keybinding";
                    example = "action.select_next_entry";
                  };
                  description = lib.mkOption {
                    type = types.nullOr types.str;
                    description = "description for keybinding";
                    default = null;
                  };
                };
              }
            );
            description = ''
              List of keybindings.
              ${desc}
            '';
            default = [ ];
            example = [
              {
                mode = "n";
                key = "<tab>";
                action = "actions.select_next_entry";
                description = "Open the diff for the next file";
              }
            ];
          };
      in
      {
        disable_defaults = defaultNullOpts.mkBool false ''
          Disable the default keymaps.
        '';

        view = keymapList ''
          The `view` bindings are active in the diff buffers, only when the current
          tabpage is a Diffview.
        '';

        diff1 = keymapList ''
          Mappings in single window diff layouts
        '';

        diff2 = keymapList ''
          Mappings in 2-way diff layouts
        '';
        diff3 = keymapList ''
          Mappings in 3-way diff layouts
        '';
        diff4 = keymapList ''
          Mappings in 4-way diff layouts
        '';
        file_panel = keymapList ''
          Mappings in file panel.
        '';
        file_history_panel = keymapList ''
          Mappings in file history panel.
        '';
        option_panel = keymapList ''
          Mappings in options panel.
        '';
        help_panel = keymapList ''
          Mappings in help panel.
        '';
      };

    disable_default_keymaps = defaultNullOpts.mkBool false ''
      Disable the default keymaps;
    '';
  };

  callSetup = false;
  extraConfig =
    cfg:
    let
      keymapCfg = cfg.settings.keymaps;
      setupOptions = cfg.settings // {
        keymaps =
          let
            convertToKeybinding = attr: [
              attr.mode
              attr.key
              attr.action
              { "desc" = attr.description; }
            ];
          in
          {
            view = map convertToKeybinding keymapCfg.view;
            diff1 = map convertToKeybinding keymapCfg.diff1;
            diff2 = map convertToKeybinding keymapCfg.diff2;
            diff3 = map convertToKeybinding keymapCfg.diff3;
            diff4 = map convertToKeybinding keymapCfg.diff4;
            file_panel = map convertToKeybinding keymapCfg.file_panel;
            file_history_panel = map convertToKeybinding keymapCfg.file_history_panel;
            option_panel = map convertToKeybinding keymapCfg.option_panel;
            help_panel = map convertToKeybinding keymapCfg.help_panel;
          };
      };
    in
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

      plugins.diffview.luaConfig.content = ''
        require("diffview").setup(${lib.nixvim.toLuaObject setupOptions})
      '';
    };

  # TODO: Deprecated 2025-10-04
  inherit (import ./deprecations.nix { inherit lib; })
    optionsRenamedToSettings
    deprecateExtraOptions
    ;
}
