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

    > [!NOTE]
    > This plugin requires you configure `plugins.oil` to allow at least 2 sign columns:
    >
    > ```nix
    > plugins.oil = {
    >   enable = true;
    >   settings = {
    >     win_options = {
    >       signcolumn = "yes:2";
    >     };
    >   };
    > };
    > ```
    >
    > Valid values include `yes` or `auto` with a "max" of at least `2`.
    > E.g. `"yes:2"` or `"auto:1-2"`.
    >
    > See [plugin docs][readme-configuration] and [`:h 'signcolumn'`]

    [readme-configuration]: https://github.com/refractalize/oil-git-status.nvim#configuration
    [`:h 'signcolumn'`]: https://neovim.io/doc/user/options.html#'signcolumn'
  '';

  maintainers = [ lib.maintainers.FKouhai ];

  # Ensure oil-git-status is set up after oil is loaded
  configLocation = lib.mkOrder 1100 "extraConfigLua";

  dependencies = [
    "git"
  ];

  extraConfig = cfg: {
    # Set the required default for plugins.oil's signcolumn:
    plugins.oil.settings.win_options.signcolumn = lib.mkDefault "yes:2";

    warnings = lib.nixvim.mkWarnings "plugins.oil-git-status" [
      {
        when = !config.plugins.oil.enable;
        message = ''
          This plugin requires `plugins.oil` to be enabled
          ${options.plugins.oil.enable} = true;
        '';
      }
      (
        # The plugin requires the oil configuration allow at least 2 sign columns.
        # They suggest `win_options.signcolumn = "yes:2"`, but valid options include
        # any "yes" or "auto" with a max > 1: E.g. "auto:2", "auto:1-2", "yes:3", …
        # See also `:h 'signcolumn'`
        let
          # Get `signcolumn` setting value
          value = config.plugins.oil.settings.win_options.signcolumn or null;

          # These valid values do not allow the sign column to use more than one column,
          # So they are incompatible with oil-git-status.
          badValue = builtins.elem value [
            "no"
            "number"
            "auto"
            "auto:1"
            "yes"
            "yes:1"
          ];

          currentValueNote =
            lib.optionalString (value != null)
              "\n`${options.plugins.oil.settings}.win_options.signcolumn` is currently set to ${
                lib.generators.toPretty { } value
              }.";
        in
        {
          when = builtins.isString value -> badValue;
          message = ''
            This plugin requires `plugins.oil` is configured to allow at least 2 sign columns.${currentValueNote}
            E.g:
              ${options.plugins.oil.settings} = {
                win_options = {
                  signcolumn = "yes:2";
                };
              };`
            See :h 'signcolumn' for more options
          '';
        }
      )
    ];
  };

  settingsExample = {
    show_ignored = false;
  };
}
