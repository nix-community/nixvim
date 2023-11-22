{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
  helpers.neovim-plugin.mkNeovimPlugin config {
    name = "neotest";
    defaultPackage = pkgs.vimPlugins.neotest;

    maintainers = [maintainers.GaetanLepage];

    imports = [
      ./adapters.nix
    ];

    extraOptions = {
      enabledAdapters = mkOption {
        type = with types;
          listOf
          (submodule {
            options = {
              name = mkOption {
                type = types.str;
              };
              settings = mkOption {
                type = with types; attrsOf anything;
              };
            };
          });
        internal = true;
        visible = false;
        default = [];
      };
    };

    settingsOptions =
      (import ./options.nix {inherit lib helpers;})
      // {
        adapters = mkOption {
          type = with helpers.nixvimTypes; listOf strLua;
          default = [];
          internal = true;
          apply = map helpers.mkRaw;
        };
      };

    settingsExample = {
      quickfix.enabled = false;
      output = {
        enabled = true;
        open_on_run = true;
      };
      output_panel = {
        enabled = true;
        open = "botright split | resize 15";
      };
    };

    extraConfig = cfg: {
      plugins.neotest.settings.adapters =
        map
        (
          adapter: let
            settingsString =
              optionalString
              (adapter.settings != {})
              "(${helpers.toLuaObject adapter.settings})";
          in "require('neotest-${adapter.name}')${settingsString}"
        )
        cfg.enabledAdapters;
    };
  }
