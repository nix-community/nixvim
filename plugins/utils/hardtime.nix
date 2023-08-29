{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.hardtime;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options = {
    plugins.hardtime =
      helpers.extraOptionsOptions
      // {
        enable = mkEnableOption "Enable hardtime.";
        package = helpers.mkPackageOption "hardtime" pkgs.vimPlugins.hardtime-nvim;

        maxTime = helpers.defaultNullOpts.mkNum 1000 ''
          Maximum time (in milliseconds) to consider key presses as repeated.
        '';

        maxCount = helpers.defaultNullOpts.mkNum 2 ''
          Maximum count of repeated key presses allowed within the `max_time` period.
        '';

        disableMouse = helpers.defaultNullOpts.mkBool true ''
          Disable mouse support.
        '';

        hint = helpers.defaultNullOpts.mkBool true ''
          Enable hint messages for better commands.
        '';

        notification = helpers.defaultNullOpts.mkBool true ''
          Enable notification messages for restricted and disabled keys.
        '';

        allowDifferentKey = helpers.defaultNullOpts.mkBool false ''
          Allow different keys to reset the count.
        '';

        enabled = helpers.defaultNullOpts.mkBool true ''
          Whether the plugin in enabled by default or not.
        '';

        # resettingKeys =
        # restrictedKeys =

        restrictionMode = helpers.defaultNullOpts.mkEnumFirstDefault ["block" "hint"] ''
          The behavior when `restricted_keys` trigger count mechanism.
        '';

        # disabledKeys =

        disabledFiletypes = helpers.mkNullOrOption (types.listOf types.str) ''
          `hardtime.nvim` is disabled under these filetypes.
        '';

        # disabledKeys =
      };
  };

  config = let
    setupOptions = {
      inherit (cfg) hint notification enabled hints;

      max_time = cfg.maxTime;
      max_count = cfg.maxCount;
      disable_mouse = cfg.disableMouse;
      allow_different_key = cfg.allowDifferentKey;
      resetting_keys = cfg.resettingKeys;
      restricted_keys = cfg.restrictedKeys;
      restriction_mode = cfg.restrictionMode;
      disabled_keys = cfg.disabledKeys;
      disabled_filetypes = cfg.disabledFiletypes;
    };
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require("hardtime").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
