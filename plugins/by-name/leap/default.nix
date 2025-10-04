{
  lib,
  ...
}:
let
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "leap";
  package = "leap-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  extraOptions = {
    addDefaultMappings = lib.mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the default mappings.";
    };
  };

  callSetup = false;
  extraConfig = cfg: {
    plugins.leap.luaConfig.content =
      lib.optionalString cfg.addDefaultMappings ''
        require('leap').add_default_mappings()
      ''
      + lib.optionalString (cfg.settings != { }) ''
        require('leap').opts = vim.tbl_deep_extend(
          "keep",
          ${lib.nixvim.toLuaObject cfg.settings},
          require('leap').opts
        )
      '';
  };

  # TODO: Deprecated 2025-10-04
  inherit (import ./deprecations.nix)
    optionsRenamedToSettings
    deprecateExtraOptions
    ;
}
