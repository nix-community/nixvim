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
  package = "nvim-cmp";

  maintainers = [ lib.maintainers.GaetanLepage ];

  description = ''
    A completion engine for Neovim written in Lua, designed to be fast and extensible.

    ---

    ### Completion Source Installation

    If `plugins.cmp.autoEnableSources` is `true` Nixvim will automatically enable the corresponding source
    plugins. This is the default behavior, but will work only when this option is set to a list.

    If you use a raw lua string or set `plugins.cmp.autoEnableSources` to `false`, you will need to explicitly enable the relevant source plugins in
    your Nixvim configuration.

    #### With auto-enabled sources
    ```nix
    plugins.cmp = {
      autoEnableSources = true;
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
    };
    ```

    #### Without auto-enabled sources
    ```nix
    plugins = {
      cmp = {
        autoEnableSources = false;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
      };
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp-buffer.enable = true;
    };

    ```
  '';

  imports = [
    ./auto-enable.nix
    ./sources
  ];

  inherit (cmpOptions) settingsOptions settingsExample;
  extraOptions = {
    inherit (cmpOptions) filetype cmdline;
  };

  callSetup = false;
  extraConfig = cfg: {
    plugins.cmp.luaConfig.content = ''
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
