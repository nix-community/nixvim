{
  lib,
  helpers,
  pkgs,
  config,
  ...
} @ args: let
  cmpOptions = import ./options {inherit lib helpers;};
in
  with lib;
    helpers.neovim-plugin.mkNeovimPlugin config {
      name = "cmp";
      originalName = "nvim-cmp";
      defaultPackage = pkgs.vimPlugins.nvim-cmp;

      maintainers = [maintainers.GaetanLepage];

      # Introduced on 2024 February 21
      # TODO: remove ~June 2024
      imports = [
        ./deprecations.nix
        ./sources
      ];
      deprecateExtraOptions = true;

      extraOptions = {
        autoEnableSources = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Scans the sources array and installs the plugins if they are known to nixvim.
          '';
        };

        inherit (cmpOptions) filetype cmdline;
      };

      inherit (cmpOptions) settingsOptions settingsExample;

      callSetup = false;
      extraConfig = cfg: {
        warnings =
          optional (cfg.autoEnableSources && (helpers.nixvimTypes.isRawType cfg.settings.sources))
          ''
            Nixvim (plugins.cmp): You have enabled `autoEnableSources` that tells Nixvim to automatically
            enable the source plugins with respect to the list of sources provided in `settings.sources`.
            However, the latter is proveded as a raw lua string which is not parseable by Nixvim.

            If you want to keep using raw lua for defining your sources:
            - Ensure you enable the relevant plugins manually in your configuration;
            - Dismiss this warning by explicitly setting `autoEnableSources` to `false`;
          '';

        extraConfigLua =
          ''
            local cmp = require('cmp')
            cmp.setup(${helpers.toLuaObject cfg.settings})

          ''
          + (concatStringsSep "\n" (
            mapAttrsToList (
              filetype: settings: "cmp.setup.filetype('${filetype}', ${helpers.toLuaObject settings})\n"
            )
            cfg.filetype
          ))
          + (concatStringsSep "\n" (
            mapAttrsToList (
              cmdtype: settings: "cmp.setup.cmdline('${cmdtype}', ${helpers.toLuaObject settings})\n"
            )
            cfg.cmdline
          ));

        # If autoEnableSources is set to true, figure out which are provided by the user
        # and enable the corresponding plugins.
        plugins = (import ./cmp-helpers.nix args).autoInstallSourcePluginsModule cfg;
      };
    }
