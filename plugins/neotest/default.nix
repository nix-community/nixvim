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

    settingsOptions =
      (import ./options.nix {inherit lib helpers;})
      // {
        adapters = mkOption {
          type = with helpers.nixvimTypes; listOf strLua;
          default = [];
          apply = map helpers.mkRaw;
          # NOTE: We hide this option from the documentation as users should use the top-level
          # `adapters` option.
          # They can still directly append raw lua code to this `settings.adapters` option.
          # In this case, they are responsible for explicitly installing the manually added adapters.
          visible = false;
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
  }
