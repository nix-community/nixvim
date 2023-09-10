{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.notify;
  helpers = import ../helpers.nix {inherit lib;};
  icon = mkOption {
    type = types.nullOr types.str;
    default = null;
  };
in {
  options.plugins.notify = {
    enable = mkEnableOption "notify";

    package = helpers.mkPackageOption "notify" pkgs.vimPlugins.nvim-notify;

    stages = mkOption {
      type = types.nullOr (types.enum ["fade_in_slide_out" "fade" "slide" "static"]);
      description = "Animation style";
      default = null;
    };
    timeout = mkOption {
      type = types.nullOr types.int;
      description = "Default timeout for notifications";
      default = null;
    };
    backgroundColour = mkOption {
      type = types.nullOr types.str;
      description = "For stages that change opacity this is treated as the highlight between the window";
      default = null;
    };
    maxWidth = mkOption {
      type = types.nullOr types.int;
      description = "Max number of columns for messages";
      default = null;
    };
    maxHeight = mkOption {
      type = types.nullOr types.int;
      description = "Max number of rows for messages";
      default = null;
    };
    minimumWidth = mkOption {
      type = types.nullOr types.int;
      description = "Minimum width for notification windows";
      default = null;
    };
    topDown = mkOption {
      type = types.nullOr types.bool;
      description = "Whether or not to position the notifications at the top or not";
      default = null;
    };
    level = mkOption {
      type = types.nullOr types.int;
      description = "Log level. See vim.log.levels";
      default = null;
    };
    icons = mkOption {
      type = types.nullOr (types.submodule {
        options = {
          error = icon;
          warn = icon;
          info = icon;
          debug = icon;
          trace = icon;
        };
      });
      description = "Icons for the different levels";
      default = {};
    };
  };

  config = let
    setupOptions = with cfg; {
      inherit stages timeout level;
      background_colour = backgroundColour;
      minimum_width = minimumWidth;
      top_down = topDown;
      max_height = maxHeight;
      max_width = maxWidth;
      icons = with icons; {
        ERROR = error;
        WARN = warn;
        INFO = info;
        DEBUG = debug;
        TRACE = trace;
      };
    };
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];
      extraConfigLua = ''
        vim.notify = require('notify');
        require('notify').setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
