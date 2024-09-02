{
  helpers,
  pkgs,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin {
  name = "bacon";
  defaultPackage = pkgs.vimPlugins.nvim-bacon;
  maintainers = [ helpers.maintainers.alisonjenkins ];

  settingsOptions = {
    quickfix = {
      enabled = helpers.defaultNullOpts.mkBool true ''
        Whether to populate the quickfix list with bacon errors and warnings.
      '';

      event_trigger = helpers.defaultNullOpts.mkBool true ''
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
