{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "bacon";
  package = "nvim-bacon";
  maintainers = [ lib.maintainers.alisonjenkins ];
  description = "View and jump to locations found in `.bacon-locations` files.";

  settingsOptions = {
    quickfix = {
      enabled = lib.nixvim.defaultNullOpts.mkBool true ''
        Whether to populate the quickfix list with bacon errors and warnings.
      '';

      event_trigger = lib.nixvim.defaultNullOpts.mkBool true ''
        Triggers the `QuickFixCmdPost` event after populating the quickfix list.
      '';
    };
  };

  settingsExample = {
    quickfix = {
      enabled = false;
      event_trigger = true;
    };
  };
}
