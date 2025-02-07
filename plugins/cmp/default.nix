{
  lib,
  ...
}:
let
  inherit (lib.nixvim) toLuaObject;

  cmpOptions = import ./options { inherit lib; };
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "cmp";
  packPathName = "nvim-cmp";
  package = "nvim-cmp";

  maintainers = [ lib.maintainers.GaetanLepage ];

  description = ''
    ### Completion Source Installation

    By default, plugins that offer a cmp source will enable the source when they are enabled.
    This can be configured or disabled using the `plugins.*.cmp` options.

    <!-- TODO:
      How should the new system work with raw-lua `sources` options?
      Maybe we should write our definitions to an internal option that can be easily read in the raw-lua and/or copied to `settings.sources`?
    -->

    #### With auto-enabled sources
    ```nix
    plugins = {
      cmp.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp-buffer.enable = true;
    };
    ```

    #### Without auto-enabled sources
    ```nix
    plugins = {
      cmp = {
        enable = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
      };
      cmp-nvim-lsp = {
        enable = true;
        cmp.enable = false;
      };
      cmp-path = {
        enable = true;
        cmp.enable = false;
      };
      cmp-buffer = {
        enable = true;
        cmp.enable = false;
      };
    };
    ```
  '';

  imports = [
    # Introduced on 2024 February 21
    # TODO: remove ~June 2024
    ./deprecations.nix
    ./sources
  ];
  deprecateExtraOptions = true;

  inherit (cmpOptions) settingsOptions settingsExample;
  extraOptions = {
    inherit (cmpOptions) filetype cmdline;
  };

  callSetup = false;
  extraConfig = cfg: {
    plugins.cmp.luaConfig.content =
      ''
        local cmp = require('cmp')
        cmp.setup(${toLuaObject cfg.settings})

      ''
      + (lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          filetype: settings: "cmp.setup.filetype('${filetype}', ${toLuaObject settings})\n"
        ) cfg.filetype
      ))
      + (lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          cmdtype: settings: "cmp.setup.cmdline('${cmdtype}', ${toLuaObject settings})\n"
        ) cfg.cmdline
      ));
  };
}
