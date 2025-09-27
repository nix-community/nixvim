{
  lib,
  ...
}:
let
  inherit (lib.nixvim)
    defaultNullOpts
    mkNullOrOption
    ;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "notify";
  package = "nvim-notify";
  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    A fancy, configurable, notification manager for Neovim.
  '';

  settingsOptions = {
    level = defaultNullOpts.mkLogLevel "info" ''
      Minimum log level to display. See `vim.log.levels`.
    '';
    timeout = defaultNullOpts.mkUnsignedInt 5000 "Default timeout for notification.";
    max_width = mkNullOrOption (with types; either ints.unsigned rawLua) ''
      Max number of columns for messages.
    '';
    max_height = mkNullOrOption (with types; either ints.unsigned rawLua) ''
      Max number of lines for a message.
    '';
    stages =
      defaultNullOpts.mkNullableWithRaw
        (
          with types;
          either (enum [
            "fade"
            "slide"
            "fade_in_slide_out"
            "static"
          ]) (listOf (types.maybeRaw str))
        )
        "fade_in_slide_out"
        ''
          Animation stages.
          Can be either one of the builtin stages or an array of lua functions.
        '';
    background_colour = defaultNullOpts.mkStr "NotifyBackground" ''
      For stages that change opacity this is treated as the highlight behind the window.
      Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function
      returning an RGB code for dynamic values.
    '';
    icons = lib.mapAttrs (name: default: defaultNullOpts.mkStr default "Icon for the ${name} level.") {
      error = "";
      warn = "";
      info = "";
      debug = "";
      trace = "✎";
    };
    on_open = defaultNullOpts.mkLuaFn "nil" ''
      Function called when a new window is opened, use for changing win settings/config.
    '';
    on_close = defaultNullOpts.mkLuaFn "nil" ''
      Function called when a new window is closed.
    '';
    render = defaultNullOpts.mkEnumFirstDefault [
      "default"
      "minimal"
      "simple"
      "compact"
      "wrapped-compact"
    ] "Function to render a notification buffer or a built-in renderer name.";
    minimum_width = defaultNullOpts.mkUnsignedInt 50 ''
      Minimum width for notification windows.
    '';
    fps = defaultNullOpts.mkPositiveInt 30 ''
      Frames per second for animation stages, higher value means smoother animations but more CPU
      usage.
    '';
    top_down = defaultNullOpts.mkBool true ''
      Whether or not to position the notifications at the top or not.
    '';
  };

  settingsExample = {
    settings = {
      level = "info";
      timeout = 5000;
      max_width = 80;
      max_height = 10;
      stages = "fade_in_slide_out";
      background_colour = "#000000";
      icons = {
        error = "";
        warn = "";
        info = "";
        debug = "";
        trace = "✎";
      };
      on_open.__raw = "function() print('Window opened') end";
      on_close.__raw = "function() print('Window closed') end";
      render = "default";
      minimum_width = 50;
      fps = 30;
      top_down = true;
    };
  };

  extraConfig = {
    plugins.notify.luaConfig.pre = ''
      vim.notify = require('notify');
    '';
  };

  # TODO: Deprecated on 2025-02-01
  inherit (import ./deprecations.nix) deprecateExtraOptions optionsRenamedToSettings;
}
