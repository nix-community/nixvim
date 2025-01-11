{ lib, pkgs, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "cornelis";
  globalPrefix = "cornelis_";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraOptions = {
    cornelisPackage = lib.mkPackageOption pkgs "cornelis" {
      nullable = true;
    };
  };

  extraConfig = cfg: {
    extraPackages = [ cfg.cornelisPackage ];
  };

  settingsOptions = {
    use_global_binary = defaultNullOpts.mkFlagInt 0 ''
      Whether to use global binary instead of stack.
    '';

    agda_prefix = defaultNullOpts.mkStr' {
      pluginDefault = "<localleader>";
      example = "<Tab>";
      description = ''
        Prefix used for agda keybindings.
      '';
    };

    no_agda_input = defaultNullOpts.mkFlagInt 0 ''
      Disable the default keybindings.
    '';

    bind_input_hook = defaultNullOpts.mkStr' {
      pluginDefault = null;
      example = "MyCustomHook";
      description = ''
        If you'd prefer to manage agda-input entirely on your own (perhaps in a snippet system), you
        can customize the bind input hook.
      '';
    };
  };

  settingsExample = {
    use_global_binary = 1;
    agda_prefix = "<Tab>";
    no_agda_input = 1;
    bind_input_hook = "MyCustomHook";
  };
}
