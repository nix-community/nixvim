{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.notify;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.notify =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "nvim-notify";

      package = helpers.mkPackageOption "nvim-notify" pkgs.vimPlugins.nvim-notify;

      level =
        helpers.defaultNullOpts.mkNullable
        (
          with types;
            oneOf [
              ints.unsigned
              helpers.rawType
              str
            ]
        )
        ''{__raw = "vim.log.levels.INFO";}''
        "Minimum log level to display. See `vim.log.levels`.";

      timeout = helpers.defaultNullOpts.mkUnsignedInt 5000 "Default timeout for notification.";

      maxWidth = helpers.mkNullOrOption (with types; either ints.unsigned helpers.rawType) ''
        Max number of columns for messages.
      '';

      maxHeight = helpers.mkNullOrOption (with types; either ints.unsigned helpers.rawType) ''
        Max number of lines for a message.
      '';

      stages =
        helpers.defaultNullOpts.mkNullable
        (
          with types;
            either
            (
              enum
              [
                "fade"
                "slide"
                "fade_in_slide_out"
                "static"
              ]
            )
            (listOf str)
        )
        "fade_in_slide_out"
        ''
          Animation stages.
          Can be either one of the builtin stages or an array of lua functions.
        '';

      backgroundColour = helpers.defaultNullOpts.mkStr "NotifyBackground" ''
        For stages that change opacity this is treated as the highlight behind the window.
        Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function
        returning an RGB code for dynamic values.
      '';

      icons =
        mapAttrs
        (
          name: default:
            helpers.defaultNullOpts.mkStr default "Icon for the ${name} level."
        )
        {
          error = "";
          warn = "";
          info = "";
          debug = "";
          trace = "✎";
        };

      onOpen = helpers.mkNullOrOption types.str ''
        Function called when a new window is opened, use for changing win settings/config.
      '';

      onClose = helpers.mkNullOrOption types.str ''
        Function called when a new window is closed.
      '';

      render =
        helpers.defaultNullOpts.mkNullable
        (
          with types;
            either
            (enum ["default" "minimal"])
            helpers.rawType
        )
        "default"
        "Function to render a notification buffer or a built-in renderer name.";

      minimumWidth = helpers.defaultNullOpts.mkUnsignedInt 50 ''
        Minimum width for notification windows.
      '';

      fps = helpers.defaultNullOpts.mkPositiveInt 30 ''
        Frames per second for animation stages, higher value means smoother animations but more CPU
        usage.
      '';

      topDown = helpers.defaultNullOpts.mkBool true ''
        Whether or not to position the notifications at the top or not.
      '';
    };

  config = let
    setupOptions = with cfg;
      {
        inherit
          level
          timeout
          ;
        max_width = maxWidth;
        max_height = maxHeight;
        stages =
          helpers.ifNonNull' stages
          (
            if isString stages
            then stages
            else map helpers.mkRaw stages
          );
        background_colour = backgroundColour;
        icons =
          mapAttrs'
          (
            name: value: {
              name = strings.toUpper name;
              inherit value;
            }
          )
          icons;
        on_open = helpers.ifNonNull' onOpen (helpers.mkRaw onOpen);
        on_close = helpers.ifNonNull' onClose (helpers.mkRaw onClose);
        inherit render;
        minimum_width = minimumWidth;
        inherit fps;
        top_down = topDown;
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        vim.notify = require('notify');
        require('notify').setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
