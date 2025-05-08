{
  lib,
  config,
  options,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "oil-git-status";
  packPathName = "oil-git-status.nvim";
  package = "oil-git-status-nvim";

  description = ''
    Add Git Status to oil.nvim directory listings.

    Git status is added to the listing asynchronously after creating the oil directory

    listing so it won't slow oil down on big repositories. The plugin puts the status in two new sign columns
    the left being the status of the index, the right being the status of the working directory

    `win_options.signcolumn` needs to be configured in `plugins.oil.settings`:
    ```nix
    plugins.oil = {
      enable = true;
      settings = {
        win_options = {
          signcolumn = "yes:2,";
        };
      };
    };
    ```
  '';

  maintainers = [ lib.maintainers.FKouhai ];

  # Ensure oil-git-status is set up after oil is loaded
  configLocation = lib.mkOrder 1100 "extraConfigLua";

  dependencies = [
    "git"
  ];

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.oil-git-status" [
      {
        when = !config.plugins.oil.enable;
        message = ''
          This plugin requires `plugins.oil` to be enabled
          ${options.plugins.oil.enable} = true;
        '';
      }
      {
        when =
          let
            value = config.plugins.oil.settings.win_options.signcolumn or null;
            isKnownBadStr = lib.lists.elem value [
              "yes"
              "yes:"
              "yes:0"
              "yes:1"
            ];
            hasYes = lib.strings.hasInfix "yes" value;
          in
          !(lib.strings.isString value && hasYes && !isKnownBadStr);

        message = ''
          This plugin requires the following `plugins.oil` setting:
            ${options.plugins.oil.settings} = {
              win_options = {
                signcolumn = "yes:2";
              };
            };`
        '';
      }
    ];
  };

  settingsExample = {
    show_ignored = false;
  };
}
