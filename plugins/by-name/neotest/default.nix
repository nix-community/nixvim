{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "neotest";
  description = "An extensible framework for interacting with tests within NeoVim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  imports = [ ./adapters.nix ];

  settingsOptions = (import ./settings-options.nix { inherit lib; }) // {
    adapters = lib.mkOption {
      type = with lib.types; listOf strLua;
      default = [ ];
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
