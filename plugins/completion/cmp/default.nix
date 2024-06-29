{
  lib,
  helpers,
  pkgs,
  config,
  ...
}@args:
let
  cmpOptions = import ./options { inherit lib helpers; };
in
with lib;
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "cmp";
  originalName = "nvim-cmp";
  defaultPackage = pkgs.vimPlugins.nvim-cmp;

  maintainers = [ maintainers.GaetanLepage ];

  imports = [
    # Introduced on 2024 February 21
    # TODO: remove ~June 2024
    ./deprecations.nix
    ./auto-enable.nix
    ./sources
  ];
  deprecateExtraOptions = true;

  inherit (cmpOptions) settingsOptions settingsExample;
  extraOptions = {
    inherit (cmpOptions) filetype cmdline;
  };

  callSetup = false;
  extraConfig = cfg: {
    extraConfigLua =
      ''
        local cmp = require('cmp')
        cmp.setup(${helpers.toLuaObject cfg.settings})

      ''
      + (concatStringsSep "\n" (
        mapAttrsToList (
          filetype: settings: "cmp.setup.filetype('${filetype}', ${helpers.toLuaObject settings})\n"
        ) cfg.filetype
      ))
      + (concatStringsSep "\n" (
        mapAttrsToList (
          cmdtype: settings: "cmp.setup.cmdline('${cmdtype}', ${helpers.toLuaObject settings})\n"
        ) cfg.cmdline
      ));
  };
}
