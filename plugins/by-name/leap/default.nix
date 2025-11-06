{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "leap";
  package = "leap-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  callSetup = false;
  extraConfig = cfg: {
    plugins.leap.luaConfig.content = lib.optionalString (cfg.settings != { }) ''
      require('leap').opts = vim.tbl_deep_extend(
        "keep",
        ${lib.nixvim.toLuaObject cfg.settings},
        require('leap').opts
      )
    '';
  };

  # TODO: Added 2025-11-07. Remove after 26.05
  imports = [
    (lib.mkRemovedOptionModule [
      "plugins"
      "leap"
      "addDefaultMappings"
    ] "See `:help leap-mappings` to update your config")
  ];

  # TODO: Deprecated 2025-10-04
  inherit (import ./deprecations.nix)
    optionsRenamedToSettings
    deprecateExtraOptions
    ;
}
